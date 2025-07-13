import {
  createClient,
  PostgrestSingleResponse,
  SupabaseClient,
} from "jsr:@supabase/supabase-js";
import pako from "https://cdn.jsdelivr.net/npm/pako@2.0.4/dist/pako.esm.mjs";
import { parse as parseCSVData } from "https://deno.land/std@0.221.0/csv/mod.ts";

interface Notification {
  id: string;
  onesignal_id: string;
  word: string | null;
  definition: string | null;
  user_id: string;
  notification_type: 'daily_reminder' | 'practice_reminder' | 'new_word' | 'streak_reminder';
}

interface OneSignalCSVExportResponse {
  csv_file_url: string;
}

async function fetchPendingNotifications(
  supabase: SupabaseClient,
  now: string,
): Promise<Notification[]> {
  const { data: pending, error } = await supabase
    .from("word_notifications")
    .select("id, onesignal_id, word, definition, user_id, notification_type")
    .eq("sent", false)
    .lte("scheduled_at", now)
    .limit(1000);

  if (error) {
    console.error("❌ Error fetching notifications:", error.message);
    throw new Error("Error fetching pending notifications");
  }

  return pending || [];
}

async function requestCSVExport(appId: string, apiKey: string) {
  const response = await fetch(
    "https://onesignal.com/api/v1/players/csv_export?app_id=" + appId,
    {
      method: "POST",
      headers: {
        "Authorization": `Basic ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        extra_fields: [
          "external_user_id",
        ],
      }),
    },
  );

  if (!response.ok) {
    const errorText = await response.text();
    console.error("❌ Error requesting CSV export:", errorText);
    throw new Error("Error requesting CSV export");
  }

  const data = await response.json() as OneSignalCSVExportResponse;
  return data.csv_file_url;
}

async function downloadCSV(
  csvUrl: string,
  maxRetries = 5,
  initialDelayMs = 2000,
): Promise<string> {
  console.log("Attempting to download CSV from URL:", csvUrl);

  // Add specific retry logic for 404 errors
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      console.log(`Download attempt ${attempt} of ${maxRetries}...`);

      const csvResponse = await fetch(csvUrl);
      if (csvResponse.status === 404) {
        if (attempt < maxRetries) {
          // Calculate exponential backoff delay
          const delayMs = initialDelayMs * Math.pow(2, attempt - 1);
          console.log(
            `CSV file not ready yet (404). Retrying in ${delayMs}ms...`,
          );
          await new Promise((resolve) => setTimeout(resolve, delayMs));
          continue; // Try again after delay
        } else {
          console.error(
            `❌ CSV file still not available after ${maxRetries} attempts`,
          );
          throw new Error(
            `CSV file not available after ${maxRetries} attempts`,
          );
        }
      }

      if (!csvResponse.ok) {
        const errorText = await csvResponse.text();
        console.error(
          `❌ Error downloading CSV: Status ${csvResponse.status}, Response:`,
          errorText,
        );
        throw new Error(`Error downloading CSV: Status ${csvResponse.status}`);
      }

      console.log("✅ CSV download successful, getting arrayBuffer...");
      const arrayBuffer = await csvResponse.arrayBuffer();
      console.log(
        `✅ Got arrayBuffer of size: ${arrayBuffer.byteLength} bytes`,
      );

      // Decompress GZ content
      try {
        const gzData = new Uint8Array(arrayBuffer);
        console.log(
          `Attempting to decompress ${gzData.length} bytes of GZ data`,
        );
        const csvText = pako.ungzip(gzData, { to: "string" }) as string;

        if (!csvText) {
          throw new Error("Failed to decompress CSV - result was empty");
        }

        console.log(
          `✅ Successfully decompressed GZ data to ${csvText.length} characters`,
        );

        // Validate CSV structure
        if (!csvText.includes(",")) {
          throw new Error("Invalid CSV format: No comma separators found");
        }

        // Log sample data for debugging
        const sampleSize = Math.min(500, csvText.length);
        console.log("CSV Data sample:", csvText.slice(0, sampleSize));

        return csvText;
      } catch (decompressError) {
        console.error("❌ Error decompressing GZ data:", decompressError);
        throw new Error(
          `Error decompressing GZ data: ${decompressError instanceof Error
            ? decompressError.message
            : String(decompressError)
          }`,
        );
      }
    } catch (fetchError) {
      if (
        fetchError instanceof Error &&
        fetchError.message.includes("CSV file not available") &&
        attempt >= maxRetries
      ) {
        // This is our final retry error, rethrow it
        throw fetchError;
      }

      if (attempt < maxRetries) {
        // For other errors, also retry with exponential backoff
        const delayMs = initialDelayMs * Math.pow(2, attempt - 1);
        console.error(
          `❌ Error in downloadCSV (attempt ${attempt}):`,
          fetchError,
        );
        console.log(`Retrying in ${delayMs}ms...`);
        await new Promise((resolve) => setTimeout(resolve, delayMs));
      } else {
        console.error(`❌ Failed after ${maxRetries} attempts:`, fetchError);
        throw new Error(
          `Error downloading CSV after ${maxRetries} attempts: ${fetchError instanceof Error
            ? fetchError.message
            : String(fetchError)
          }`,
        );
      }
    }
  }

  // This should never be reached due to the throw in the loop, but TypeScript needs it
  throw new Error("Failed to download CSV after all retry attempts");
}

function parseCSV(csvText: string, userId: string): string {
  // Parse CSV without specifying columns to get all fields
  const rows = parseCSVData(csvText, {
    skipFirstRow: false, // Don't skip so we can see the headers
  });

  if (rows.length < 2) {
    console.error("❌ CSV file is empty or malformed");
    return "";
  }

  // Get header row and find our column indices
  const headers = rows[0];
  const externalUserIdIndex = headers.indexOf("external_user_id");
  const invalidIdentifierIndex = headers.indexOf("invalid_identifier");

  console.log("CSV Headers:", headers);
  console.log("Column indices - external_user_id:", externalUserIdIndex, "invalid_identifier:", invalidIdentifierIndex);

  if (externalUserIdIndex === -1) {
    console.error("❌ Could not find external_user_id column");
    return "";
  }

  // Process data rows (skip header row)
  for (let i = 1; i < rows.length; i++) {
    const row = rows[i];
    const externalUserId = row[externalUserIdIndex]?.trim();
    // Only check invalidIdentifier if the column exists
    const invalidIdentifier = invalidIdentifierIndex !== -1
      ? row[invalidIdentifierIndex]?.trim().toLowerCase()
      : "f"; // Default to subscribed if column doesn't exist

    if (externalUserId === userId) {
      if (invalidIdentifier === "f") {
        console.log(`✅ User ${userId} is subscribed.`);
        return externalUserId;
      } else {
        console.log(`❌ User ${userId} is unsubscribed.`);
        return "";
      }
    }
  }

  console.log(`❌ User ${userId} not found in CSV.`);
  return "";
}

// Function to generate notification content based on type
function getNotificationContent(notification: Notification): { heading: string; content: string } {
  switch (notification.notification_type) {
    case 'daily_reminder':
      return {
        heading: "Daily Practice Reminder 📚",
        content: "Time to expand your vocabulary! Start your daily practice session now."
      };
    case 'practice_reminder':
      return {
        heading: "Don't Break Your Streak! 🔥",
        content: "You haven't practiced recently. Keep your learning momentum going!"
      };
    case 'new_word':
      return {
        heading: notification.word || "New Word",
        content: notification.definition || "Learn a new word today!"
      };
    case 'streak_reminder':
      return {
        heading: "Streak Alert! ⚡",
        content: "Your learning streak is at risk! Practice now to keep it alive."
      };
    default:
      return {
        heading: "WordStock Reminder",
        content: "Time to practice your vocabulary!"
      };
  }
}

async function sendNotifications(
  supabase: SupabaseClient,
  userId: string,
  pending: Notification[],
  appId: string,
  apiKey: string,
) {
  const sendPromises: Promise<unknown>[] = [];

  for (const notif of pending) {
    const { heading, content } = getNotificationContent(notif);
    
    sendPromises.push(
      fetch(
        "https://onesignal.com/api/v1/notifications",
        {
          method: "POST",
          headers: {
            "Authorization": `Basic ${apiKey}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            app_id: appId,
            include_external_user_ids: [userId],
            contents: { en: content },
            headings: { en: heading },
          }),
        },
      ).then(async (response) => {
        const result = await response.json();

        if (!response.ok || result.errors) {
          console.error(
            `❌ OneSignal error for notification ${notif.id} (${notif.notification_type}):`,
            result,
          );
          return;
        }

        console.log(`✅ OneSignal ${notif.notification_type} notification sent for ID ${notif.id}`);

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
          `❌ Failed to send to OneSignal for ID ${notif.id} (${notif.notification_type}):`,
          e instanceof Error ? e.message : String(e),
        );
      }),
    );
  }

  await Promise.all(sendPromises);
}

async function updateNotificationsAsSent(
  supabase: SupabaseClient,
  pending: Notification[],
) {
  const updatePromises = pending.map((notif) =>
    supabase
      .from("word_notifications")
      .update({ sent: true })
      .eq("id", notif.id)
      .then((result: PostgrestSingleResponse<null>) => {
        if (result.error) {
          console.error(
            `❌ Error updating notification ${notif.id}:`,
            result.error,
          );
        } else {
          console.log(
            `✅ Notification ${notif.id} marked as sent (no subscribed devices)`,
          );
        }
        return result;
      })
  );

  await Promise.all(updatePromises);
}

// New function to group notifications by user
function groupNotificationsByUser(notifications: Notification[]): Map<string, Notification[]> {
  const userNotifications = new Map<string, Notification[]>();

  for (const notification of notifications) {
    const userNotifs = userNotifications.get(notification.user_id) || [];
    userNotifs.push(notification);
    userNotifications.set(notification.user_id, userNotifs);
  }

  return userNotifications;
}

// Function to check user notification settings based on notification type
async function checkUserNotificationSettings(
  supabase: SupabaseClient,
  userId: string,
  notificationType: string,
): Promise<boolean> {
  try {
    const { data: user, error } = await supabase
      .from("user_profiles")
      .select(
        "notifications_enabled, daily_reminder_enabled, practice_reminder_enabled, new_word_notification_enabled, streak_reminder_enabled"
      )
      .eq("user_id", userId)
      .single();

    if (error) {
      console.error(`❌ Error fetching user settings for ${userId}:`, error);
      return false; // Default to not sending if we can't check settings
    }

    // Check if global notifications are enabled first
    if (!user.notifications_enabled) {
      return false;
    }

    // Check specific notification type setting
    switch (notificationType) {
      case 'daily_reminder':
        return user.daily_reminder_enabled === true;
      case 'practice_reminder':
        return user.practice_reminder_enabled === true;
      case 'new_word':
        return user.new_word_notification_enabled === true;
      case 'streak_reminder':
        return user.streak_reminder_enabled === true;
      default:
        console.error(`❌ Unknown notification type: ${notificationType}`);
        return false;
    }
  } catch (error) {
    console.error(`❌ Error checking user settings for ${userId}:`, error);
    return false; // Default to not sending if there's an error
  }
}

// Update main processing logic
Deno.serve(async () => {
  const supabase: SupabaseClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_REST_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  console.log("ONE_SIGNAL_REST_API_KEY:", ONE_SIGNAL_REST_API_KEY);
  const now = new Date().toISOString();

  console.log("Time now:", now);

  try {
    const pending = await fetchPendingNotifications(supabase, now);

    if (!pending || pending.length === 0) {
      console.log("✅ No notifications to send at this time");
      return new Response("No pending notifications", { status: 200 });
    }

    console.log(`Found ${pending.length} total pending notifications`);

    // Group notifications by user
    const userNotifications = groupNotificationsByUser(pending);
    console.log(`Processing notifications for ${userNotifications.size} users`);

    // Get CSV export for subscription status
    const csvUrl = await requestCSVExport(
      ONE_SIGNAL_APP_ID,
      ONE_SIGNAL_REST_API_KEY,
    );

    console.log("CSV URL:", csvUrl);
    const csvText = await downloadCSV(csvUrl);

    // Process each user's notifications
    const processPromises: Promise<void>[] = [];

    for (const [userId, notifications] of userNotifications) {
      processPromises.push((async () => {
        console.log(`Processing ${notifications.length} notifications for user ${userId}`);

        // Check user's notification settings for each notification type
        const notificationsToSend: Notification[] = [];
        const notificationsToSkip: Notification[] = [];

        for (const notification of notifications) {
          const isEnabled = await checkUserNotificationSettings(
            supabase, 
            userId, 
            notification.notification_type
          );
          
          if (isEnabled) {
            notificationsToSend.push(notification);
          } else {
            notificationsToSkip.push(notification);
            console.log(
              `⏩ Skipping ${notification.notification_type} notification: User ${userId} has this type disabled`,
            );
          }
        }

        // Mark skipped notifications as sent
        if (notificationsToSkip.length > 0) {
          await updateNotificationsAsSent(supabase, notificationsToSkip);
        }

        // Send enabled notifications
        if (notificationsToSend.length === 0) {
          console.log(`⏩ No enabled notifications to send for user ${userId}`);
          return;
        }

        const validUserId = parseCSV(csvText, userId);

        if (!validUserId) {
          console.log(
            `⏩ Skipping notifications: No valid subscription found for user ${userId}`,
          );
          await updateNotificationsAsSent(supabase, notifications);
          return;
        }

        await sendNotifications(
          supabase,
          validUserId,
          notificationsToSend,
          ONE_SIGNAL_APP_ID,
          ONE_SIGNAL_REST_API_KEY,
        );
      })());
    }

    // Wait for all user notifications to be processed
    await Promise.all(processPromises);

    return new Response("✅ All notification types processed", { status: 200 });
  } catch (error) {
    console.error("❌ Error processing notifications:", error);
    return new Response("Error processing notifications", { status: 500 });
  }
});
