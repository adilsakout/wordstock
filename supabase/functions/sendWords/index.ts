import {
  createClient,
  SupabaseClient,
} from "jsr:@supabase/supabase-js";

interface Notification {
  id: string;
  onesignal_id: string;
  word: string | null;
  definition: string | null;
  user_id: string;
  notification_type: "daily_reminder" | "practice_reminder" | "new_word" | "streak_reminder";
  scheduled_at: string;
}

interface UserNotificationSettings {
  notifications_enabled: boolean;
  daily_reminder_enabled: boolean;
  practice_reminder_enabled: boolean;
  new_word_notification_enabled: boolean;
  streak_reminder_enabled: boolean;
}

async function fetchPendingNotifications(
  supabase: SupabaseClient,
  now: string,
): Promise<Notification[]> {
  const { data: pending, error } = await supabase
    .from("word_notifications")
    .select("id, onesignal_id, word, definition, user_id, notification_type, scheduled_at")
    .eq("sent", false)
    .lte("scheduled_at", now)
    .limit(1000);

  if (error) {
    console.error("❌ Error fetching notifications:", error.message);
    throw new Error("Error fetching pending notifications");
  }

  return pending || [];
}

async function markNotificationsAsSent(
  supabase: SupabaseClient,
  ids: string[],
): Promise<void> {
  if (ids.length === 0) return;
  const { error } = await supabase
    .from("word_notifications")
    .update({ sent: true })
    .in("id", ids);

  if (error) {
    console.error("❌ Error marking notifications as sent:", error.message);
  }
}

async function bulkClearStaleNotifications(
  supabase: SupabaseClient,
  cutoff: string,
): Promise<void> {
  const { error, count } = await supabase
    .from("word_notifications")
    .update({ sent: true })
    .eq("sent", false)
    .lt("scheduled_at", cutoff);

  if (error) {
    console.error("❌ Error clearing stale notifications:", error.message);
  } else {
    console.log(`🗑 Cleared ${count ?? "unknown"} stale notifications (>24h old)`);
  }
}

function getNotificationContent(notification: Notification): { heading: string; content: string } {
  switch (notification.notification_type) {
    case "daily_reminder":
      return {
        heading: "Daily Practice Reminder 📚",
        content: "Time to expand your vocabulary! Start your daily practice session now.",
      };
    case "practice_reminder":
      return {
        heading: "Don't Break Your Streak! 🔥",
        content: "You haven't practiced recently. Keep your learning momentum going!",
      };
    case "new_word":
      return {
        heading: notification.word || "New Word",
        content: notification.definition || "Learn a new word today!",
      };
    case "streak_reminder":
      return {
        heading: "Streak Alert! ⚡",
        content: "Your learning streak is at risk! Practice now to keep it alive.",
      };
    default:
      return {
        heading: "WordStock Reminder",
        content: "Time to practice your vocabulary!",
      };
  }
}

async function sendOneSignalNotification(
  notif: Notification,
  appId: string,
  apiKey: string,
): Promise<boolean> {
  const { heading, content } = getNotificationContent(notif);

  try {
    const response = await fetch("https://api.onesignal.com/notifications?c=push", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Key ${apiKey}`,
      },
      body: JSON.stringify({
        app_id: appId,
        include_subscription_ids: [notif.onesignal_id],
        headings: { en: heading },
        contents: { en: content },
      }),
    });

    const result = await response.json();

    if (!response.ok || result.errors) {
      console.error(
        `❌ OneSignal error for notification ${notif.id} (${notif.notification_type}):`,
        result.errors || result,
      );
      return false;
    }

    console.log(`✅ Sent ${notif.notification_type} for user ${notif.user_id}`);
    return true;
  } catch (err) {
    console.error(
      `❌ Network error for notification ${notif.id}:`,
      err instanceof Error ? err.message : String(err),
    );
    return false;
  }
}

function groupByUser(notifications: Notification[]): Map<string, Notification[]> {
  const map = new Map<string, Notification[]>();
  for (const notif of notifications) {
    const list = map.get(notif.user_id) || [];
    list.push(notif);
    map.set(notif.user_id, list);
  }
  return map;
}

async function fetchUserSettings(
  supabase: SupabaseClient,
  userId: string,
): Promise<UserNotificationSettings | null> {
  const { data, error } = await supabase
    .from("user_profiles")
    .select(
      "notifications_enabled, daily_reminder_enabled, practice_reminder_enabled, new_word_notification_enabled, streak_reminder_enabled",
    )
    .eq("user_id", userId)
    .single();

  if (error || !data) {
    console.error(`❌ Error fetching settings for user ${userId}:`, error?.message);
    return null;
  }

  return data as UserNotificationSettings;
}

function isTypeEnabled(settings: UserNotificationSettings, type: string): boolean {
  if (!settings.notifications_enabled) return false;
  switch (type) {
    case "daily_reminder": return settings.daily_reminder_enabled === true;
    case "practice_reminder": return settings.practice_reminder_enabled === true;
    case "new_word": return settings.new_word_notification_enabled === true;
    case "streak_reminder": return settings.streak_reminder_enabled === true;
    default: return false;
  }
}

Deno.serve(async () => {
  const supabase: SupabaseClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  const now = new Date();
  const nowISO = now.toISOString();
  // Cutoff: skip notifications older than 24 hours
  const cutoffISO = new Date(now.getTime() - 24 * 60 * 60 * 1000).toISOString();

  console.log("⏰ Processing notifications at:", nowISO);

  try {
    // Step 1: Bulk-clear all stale notifications in one DB call (clears the backlog)
    await bulkClearStaleNotifications(supabase, cutoffISO);

    // Step 2: Fetch current pending notifications (scheduled within last 24h)
    const pending = await fetchPendingNotifications(supabase, nowISO);

    if (!pending || pending.length === 0) {
      console.log("✅ No notifications to send at this time");
      return new Response("No pending notifications", { status: 200 });
    }

    console.log(`📋 Found ${pending.length} notifications to process`);

    const userNotifications = groupByUser(pending);
    console.log(`👥 Processing for ${userNotifications.size} users`);

    const processPromises: Promise<void>[] = [];

    for (const [userId, notifications] of userNotifications) {
      processPromises.push((async () => {
        // Fetch user settings once per user (not per notification)
        const settings = await fetchUserSettings(supabase, userId);

        const toSendIds: string[] = [];
        const toSkipIds: string[] = [];

        for (const notif of notifications) {
          if (settings && isTypeEnabled(settings, notif.notification_type)) {
            toSendIds.push(notif.id);
          } else {
            toSkipIds.push(notif.id);
            console.log(`⏩ Skipping ${notif.notification_type} for user ${userId} (disabled)`);
          }
        }

        // Mark disabled notifications as sent without sending
        if (toSkipIds.length > 0) {
          await markNotificationsAsSent(supabase, toSkipIds);
        }

        // Send enabled notifications
        const toSendNotifs = notifications.filter(n => toSendIds.includes(n.id));
        const sentIds: string[] = [];

        for (const notif of toSendNotifs) {
          const success = await sendOneSignalNotification(notif, ONE_SIGNAL_APP_ID, ONE_SIGNAL_API_KEY);
          if (success) sentIds.push(notif.id);
        }

        if (sentIds.length > 0) {
          await markNotificationsAsSent(supabase, sentIds);
        }
      })());
    }

    await Promise.all(processPromises);

    return new Response("✅ Notifications processed", { status: 200 });
  } catch (error) {
    console.error("❌ Error processing notifications:", error);
    return new Response("Error processing notifications", { status: 500 });
  }
});
