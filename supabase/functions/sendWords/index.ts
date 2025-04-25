import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

// Define interfaces for OneSignal user data
interface OneSignalSubscription {
  id: string;
  type: number; // 0: iOS, 1: Android, 11: Web Push, etc.
  invalid_identifier: boolean;
  device_type?: number;
}

interface OneSignalUserData {
  identity?: {
    external_id?: string;
  };
  subscriptions?: OneSignalSubscription[];
}

interface OneSignalUserResponse {
  users: OneSignalUserData[];
}

Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;
  const now = new Date().toISOString();

  // 1. Get all pending and due notifications
  const { data: pending, error } = await supabase
    .from("word_notifications")
    .select("id, onesignal_id, word, definition, user_id")
    .eq("sent", false)
    .lte("scheduled_at", now)
    .limit(100);

  if (error) {
    console.error("❌ Error fetching notifications:", error.message);
    return new Response("Error fetching pending notifications", {
      status: 500,
    });
  }

  if (!pending || pending.length === 0) {
    console.log("✅ No notifications to send at this time");
    return new Response("No pending notifications", { status: 200 });
  }

  // Get unique user IDs from pending notifications
  const userIds = [...new Set(pending.map((notif) => notif.user_id))];

  // 2. Fetch all users' subscription status at once
  const userCheckResponse = await fetch(
    `https://api.onesignal.com/apps/${ONE_SIGNAL_APP_ID}/users/by/external_ids`,
    {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${ONE_SIGNAL_API_KEY}`,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify({
        external_ids: userIds,
      }),
    },
  );

  if (!userCheckResponse.ok) {
    console.error(
      "❌ Error fetching user subscriptions:",
      await userCheckResponse.text(),
    );
    return new Response("Error fetching user subscriptions", { status: 500 });
  }

  const userData = await userCheckResponse.json() as OneSignalUserResponse;

  // Create a map of valid push subscriptions by user_id
  const validUserMap = new Map<string, boolean>();

  userData.users.forEach((user) => {
    if (user.identity?.external_id) {
      // Check if user has any valid push subscription
      const hasValidPushSubscription = user.subscriptions?.some(
        (sub: OneSignalSubscription) =>
          !sub.invalid_identifier &&
          (sub.type === 0 || sub.type === 1 || sub.type === 11), // iOS, Android, Web
      ) ?? false;

      validUserMap.set(user.identity.external_id, hasValidPushSubscription);
    }
  });

  // 3. Process notifications
  const updatePromises: Promise<unknown>[] = [];
  const sendPromises: Promise<unknown>[] = [];

  for (const notif of pending) {
    const isValidUser = validUserMap.get(notif.user_id);

    if (!isValidUser) {
      console.log(
        `⏩ Skipping notification for user ${notif.user_id}: No valid push subscription`,
      );
      // Mark as sent to prevent retries
      const updatePromise = Promise.resolve(
        supabase
          .from("word_notifications")
          .update({ sent: true })
          .eq("id", notif.id),
      ).then((result) => {
        if (result.error) {
          console.error(
            `❌ Error updating notification ${notif.id}:`,
            result.error,
          );
        }
        return result;
      });

      updatePromises.push(updatePromise);
      continue;
    }

    // User has a valid push subscription, queue the notification
    sendPromises.push(
      fetch(
        "https://api.onesignal.com/notifications?c=push",
        {
          method: "POST",
          headers: {
            "Authorization": `Key ${ONE_SIGNAL_API_KEY}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            app_id: ONE_SIGNAL_APP_ID,
            include_aliases: {
              external_id: [notif.user_id],
            },
            target_channel: "push",
            headings: { en: notif.word },
            contents: { en: notif.definition },
          }),
        },
      ).then(async (response) => {
        const result = await response.json();

        if (!response.ok || result.errors) {
          console.error(`❌ OneSignal error for ID ${notif.id}:`, result);
          return;
        } else {
          console.log(`✅ OneSignal notification sent for ID ${notif.id}`);
        }

        // Mark notification as sent
        const updateResult = await supabase
          .from("word_notifications")
          .update({ sent: true })
          .eq("id", notif.id);

        if (updateResult.error) {
          console.error(
            `❌ Error updating notification ${notif.id}:`,
            updateResult.error,
          );
        } else {
          console.log(`✅ Notification ${notif.id} updated as sent`);
        }

        return updateResult;
      }).catch((e: unknown) => {
        console.error(
          `❌ Failed to send to OneSignal for ID ${notif.id}:`,
          e instanceof Error ? e.message : String(e),
        );
      }),
    );
  }

  // Wait for all updates and sends to complete
  await Promise.all([...updatePromises, ...sendPromises]);

  return new Response("✅ Notifications processed", { status: 200 });
});
