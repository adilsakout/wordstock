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
 * - Haven't been active for 24+ hours (or never active)
 */
Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  const now = new Date();

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
      JSON.stringify({ message: "No users eligible for practice reminders" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  // Include users who have never been active OR haven't been active for 24+ hours
  const eligibleUsers = users.filter((user) => {
    if (!user.last_active_date) return true; // Never active → eligible
    const hoursSinceActive =
      (now.getTime() - new Date(user.last_active_date).getTime()) / (1000 * 60 * 60);
    return hoursSinceActive >= 24;
  });

  if (eligibleUsers.length === 0) {
    return new Response(
      JSON.stringify({ message: "No users have been inactive for 24+ hours" }),
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

  console.log(`🔔 Sending practice reminder to ${onesignalIds.length} users`);

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    include_subscription_ids: onesignalIds,
    headings: { en: "Don't Break Your Streak! 🔥" },
    contents: { en: "You haven't practiced recently. Keep your learning momentum going!" },
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

    console.log("🔔 Practice reminder sent successfully:", result);
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Failed to send practice reminder notifications" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
