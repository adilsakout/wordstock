// wordOfTheDay/index.ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  // Fetch users with a valid OneSignal ID and global notifications enabled
  const { data: users, error } = await supabase
    .from("user_profiles")
    .select("onesignal_id")
    .not("onesignal_id", "is", null)
    .eq("notifications_enabled", true);

  if (error) {
    console.error("❌ Supabase error:", error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  const onesignalIds = users?.map((u) => u.onesignal_id).filter(Boolean) ?? [];

  if (onesignalIds.length === 0) {
    return new Response(JSON.stringify({ message: "No users to notify" }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  console.log(`🔔 Sending word of the day to ${onesignalIds.length} users`);

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    include_subscription_ids: onesignalIds,
    headings: { en: "Word of the Day 🌟" },
    contents: { en: "Discover today's word and grow your vocabulary!" },
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

    console.log("🔔 Word of the day notification sent successfully:", result);
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Failed to send notification" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
