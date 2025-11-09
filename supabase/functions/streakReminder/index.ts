// streakReminder/index.ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

/**
 * Streak Reminder Notification Function
 * 
 * Sends streak reminder notifications to users who have:
 * - Global notifications enabled
 * - Streak reminder notifications enabled
 * - Valid OneSignal ID
 * - An active streak (daily_streak > 0)
 * - Haven't been active today (streak at risk)
 * 
 * This function helps users maintain their learning consistency by alerting
 * them when their streak is at risk of being broken.
 */
Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  const now = new Date();
  const today = new Date(now);
  today.setHours(0, 0, 0, 0);

  // 🔍 Fetch users with:
  // - Valid OneSignal ID
  // - Global notifications enabled
  // - Streak reminder notifications enabled
  // - Active streak (daily_streak > 0)
  const { data: users, error } = await supabase
    .from("user_profiles")
    .select("onesignal_id, user_id, daily_streak, last_active_date")
    .not("onesignal_id", "is", null)
    .eq("notifications_enabled", true)
    .eq("streak_reminder_enabled", true)
    .gt("daily_streak", 0);

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
        message: "No users with active streaks and streak reminders enabled",
      }),
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  // Filter users who haven't been active today (streak at risk)
  const eligibleUsers = users.filter((user) => {
    if (!user.last_active_date) {
      return true; // Never active but has a streak, eligible for reminder
    }
    const lastActive = new Date(user.last_active_date);
    const lastActiveDate = new Date(lastActive);
    lastActiveDate.setHours(0, 0, 0, 0);
    
    // Check if user was active today
    const isActiveToday = lastActiveDate.getTime() === today.getTime();
    return !isActiveToday; // Only send if NOT active today
  });

  if (eligibleUsers.length === 0) {
    return new Response(
      JSON.stringify({
        message: "All users with streaks have been active today",
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
    `🔔 Sending streak reminder notifications to ${onesignalIds.length} users`,
  );

  // Get the highest streak count for a more personalized message
  const maxStreak = Math.max(...eligibleUsers.map((u) => u.daily_streak || 0));

  const title = "Streak Alert! ⚡";
  const message =
    `Your ${maxStreak > 0 ? `${maxStreak}-day ` : ""}learning streak is at risk! Practice now to keep it alive.`;

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    included_segments: ["All"],
    delayed_option: "timezone",
    delivery_time_of_day: "8:00PM",
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
      console.log("🔔 Streak reminder notifications sent successfully:", result);
    }

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({
        error: "Failed to send streak reminder notifications",
        err,
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      },
    );
  }
});

