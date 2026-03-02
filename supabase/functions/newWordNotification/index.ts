// newWordNotification/index.ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

/**
 * New Word Notification Function
 *
 * Sends a random word notification to users who have:
 * - Global notifications enabled
 * - New word notifications enabled
 * - Valid OneSignal ID
 */
Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const ONE_SIGNAL_APP_ID = Deno.env.get("ONESIGNAL_APP_ID")!;
  const ONE_SIGNAL_API_KEY = Deno.env.get("ONESIGNAL_API_KEY")!;

  const { data: users, error: userError } = await supabase
    .from("user_profiles")
    .select("onesignal_id, user_id")
    .not("onesignal_id", "is", null)
    .eq("notifications_enabled", true)
    .eq("new_word_notification_enabled", true);

  if (userError) {
    console.error("❌ Supabase error fetching users:", userError.message);
    return new Response(JSON.stringify({ error: userError.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!users || users.length === 0) {
    return new Response(
      JSON.stringify({ message: "No users with new word notifications enabled" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  // Fetch a random word
  const { data: words, error: wordError } = await supabase
    .from("words")
    .select("word, definition")
    .limit(100);

  if (wordError || !words || words.length === 0) {
    console.error("❌ Error fetching words:", wordError?.message);
    return new Response(
      JSON.stringify({ error: "Failed to fetch words from database" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  const randomWord = words[Math.floor(Math.random() * words.length)];
  const onesignalIds = users.map((u) => u.onesignal_id).filter(Boolean);

  if (onesignalIds.length === 0) {
    return new Response(
      JSON.stringify({ message: "No valid OneSignal IDs found" }),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  console.log(`🔔 Sending new word notification to ${onesignalIds.length} users`);
  console.log(`📚 Selected word: ${randomWord.word}`);

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    include_subscription_ids: onesignalIds,
    headings: { en: randomWord.word || "New Word" },
    contents: { en: randomWord.definition || "Learn a new word today!" },
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

    console.log("🔔 New word notification sent successfully:", result);
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Failed to send new word notifications" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
