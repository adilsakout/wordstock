// practiceReminder/index.ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

/**
 * Practice Reminder Notification Function
 * 
 * Sends practice reminder notifications to users who have:
 * - Global notifications enabled
 * - Practice reminder notifications enabled
 * - Valid OneSignal ID
 * - Haven't been active for 24+ hours
 * 
 * This function encourages users to return to the app when they haven't
 * practiced for a while, helping maintain engagement and learning momentum.
 */
Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  const now = new Date();

  // 🔍 Fetch users with:
  // - Valid OneSignal ID
  // - Global notifications enabled
  // - Practice reminder notifications enabled
  // We'll filter by last_active_date in JavaScript for reliability
  const { data: users, error } = await supabase
    .from("user_profiles")
    .select("onesignal_id, user_id, last_active_date")
    .not("onesignal_id", "is", null)
    .eq("notifications_enabled", true)
    .eq("practice_reminder_enabled", true);

  if (error) {
    console.error("❌ Supabase error:", error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!users || users.length === 0) {
    return new Response(
      JSON.stringify({
        message: "No users eligible for practice reminders",
      }),
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  // Filter users who haven't been active for 24+ hours
  const eligibleUsers = users.filter((user) => {
    if (!user.last_active_date) {
      return true; // Never active, eligible for reminder
    }
    const lastActive = new Date(user.last_active_date);
    const hoursSinceActive = (now.getTime() - lastActive.getTime()) /
      (1000 * 60 * 60);
    return hoursSinceActive >= 24;
  });

  if (eligibleUsers.length === 0) {
    return new Response(
      JSON.stringify({
        message: "No users have been inactive for 24+ hours",
      }),
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  const onesignalIds = eligibleUsers
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
    `🔔 Sending practice reminder notifications to ${onesignalIds.length} users`,
  );

  const title = "Don't Break Your Streak! 🔥";
  const message =
    "You haven't practiced recently. Keep your learning momentum going!";

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    included_segments: ["All"],
    delayed_option: "timezone",
    delivery_time_of_day: "6:00PM",
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
      console.log(
        "🔔 Practice reminder notifications sent successfully:",
        result,
      );
    }

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({
        error: "Failed to send practice reminder notifications",
        err,
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      },
    );
  }
});

