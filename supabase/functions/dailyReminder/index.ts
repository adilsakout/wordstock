// dailyReminder/index.ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

/**
 * Daily Reminder Notification Function
 * 
 * Sends daily reminder notifications to users who have:
 * - Global notifications enabled
 * - Daily reminder notifications enabled
 * - Valid OneSignal ID
 * 
 * This function is designed to be called on a schedule (e.g., daily at 9 AM)
 * to remind users to practice their vocabulary.
 */
Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  // 🔍 Fetch users with:
  // - Valid OneSignal ID
  // - Global notifications enabled
  // - Daily reminder notifications enabled
  const { data: users, error } = await supabase
    .from("user_profiles")
    .select("onesignal_id, user_id")
    .not("onesignal_id", "is", null)
    .eq("notifications_enabled", true)
    .eq("daily_reminder_enabled", true);

  if (error) {
    console.error("❌ Supabase error:", error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!users || users.length === 0) {
    return new Response(
      JSON.stringify({ message: "No users with daily reminders enabled" }),
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  const onesignalIds = users
    .map((u) => u.onesignal_id)
    .filter(Boolean);

  if (onesignalIds.length === 0) {
    return new Response(
      JSON.stringify({ message: "No valid OneSignal IDs found" }),
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  console.log(
    `🔔 Sending daily reminder notifications to ${onesignalIds.length} users`,
  );

  const title = "Daily Practice Reminder 📚";
  const message =
    "Time to expand your vocabulary! Start your daily practice session now.";

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    included_segments: ["All"],
    delayed_option: "timezone",
    delivery_time_of_day: "9:00AM",
    headings: { en: title },
    contents: { en: message },
  };

  try {
    const onesignalRes = await fetch(
      "https://api.onesignal.com/notifications?c=push",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Key ${ONE_SIGNAL_API_KEY}`,
          Accept: "application/json",
        },
        body: JSON.stringify(notificationPayload),
      },
    );

    const result = await onesignalRes.json();

    if (!onesignalRes.ok) {
      console.error("❌ OneSignal error:", result.errors || result);
      return new Response(
        JSON.stringify({ error: result.errors || result }),
        {
          status: onesignalRes.status,
          headers: { "Content-Type": "application/json" },
        },
      );
    } else {
      console.log("🔔 Daily reminder notifications sent successfully:", result);
    }

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Failed to send daily reminder notifications", err }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      },
    );
  }
});

