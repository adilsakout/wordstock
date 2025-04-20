import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

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
    .select("id, onesignal_id, word, definition")
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

  // 2. Loop through notifications and send using fetch
  for (const notif of pending) {
    try {
      const response = await fetch(
        "https://onesignal.com/api/v1/notifications",
        {
          method: "POST",
          headers: {
            "Authorization": `Basic ${ONE_SIGNAL_API_KEY}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            app_id: ONE_SIGNAL_APP_ID,
            include_player_ids: [notif.onesignal_id],
            headings: { en: notif.word },
            contents: { en: notif.definition },
          }),
        },
      );

      const result = await response.json();

      if (!response.ok || result.errors) {
        console.error(`❌ OneSignal error for ID ${notif.id}:`, result);
        continue;
      }

      // 3. Mark notification as sent
      await supabase
        .from("word_notifications")
        .update({ sent: true })
        .eq("id", notif.id);
    } catch (e: unknown) {
      console.error(
        `❌ Failed to send to OneSignal for ID ${notif.id}:`,
        e instanceof Error ? e.message : String(e),
      );
    }
  }

  return new Response("✅ Notifications sent", { status: 200 });
});
