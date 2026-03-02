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
 */
Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  const now = new Date();
  const todayUTC = now.toISOString().slice(0, 10); // "YYYY-MM-DD" in UTC

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
      JSON.stringify({ message: "No users with active streaks and streak reminders enabled" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  // Filter users who haven't been active today (streak at risk)
  const eligibleUsers = users.filter((user) => {
    if (!user.last_active_date) return true;
    const lastActiveDateStr = new Date(user.last_active_date).toISOString().slice(0, 10);
    return lastActiveDateStr !== todayUTC;
  });

  if (eligibleUsers.length === 0) {
    return new Response(
      JSON.stringify({ message: "All users with streaks have been active today" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  const onesignalIds = eligibleUsers.map((u) => u.onesignal_id).filter(Boolean);

  if (onesignalIds.length === 0) {
    return new Response(
      JSON.stringify({ message: "No valid OneSignal IDs found" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  console.log(`🔔 Sending streak reminder to ${onesignalIds.length} users`);

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    include_subscription_ids: onesignalIds,
    headings: { en: "Streak Alert! ⚡" },
    // Generic message — streak count varies per user so we don't show one user's streak to all
    contents: { en: "Your learning streak is at risk! Practice now to keep it alive." },
  };

  try {
    const onesignalRes = await fetch("https://api.onesignal.com/notifications?c=push", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Key ${ONE_SIGNAL_API_KEY}`,
        Accept: "application/json",
      },
      body: JSON.stringify(notificationPayload),
    });

    const result = await onesignalRes.json();

    if (!onesignalRes.ok) {
      console.error("❌ OneSignal error:", result.errors || result);
      return new Response(JSON.stringify({ error: result.errors || result }), {
        status: onesignalRes.status,
        headers: { "Content-Type": "application/json" },
      });
    }

    console.log("🔔 Streak reminder sent successfully:", result);
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Failed to send streak reminder notifications" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
