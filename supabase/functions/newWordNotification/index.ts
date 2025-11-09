// newWordNotification/index.ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

/**
 * New Word Notification Function
 * 
 * Sends new word notifications to users who have:
 * - Global notifications enabled
 * - New word notifications enabled
 * - Valid OneSignal ID
 * 
 * This function sends a random word with its definition to help users
 * discover new vocabulary and expand their knowledge.
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
  // - New word notifications enabled
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
      {
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  // 📚 Fetch a random word from the database
  // We'll fetch multiple words and randomly select one for each user
  const { data: words, error: wordError } = await supabase
    .from("words")
    .select("word, definition")
    .limit(100); // Fetch 100 words to have variety

  if (wordError || !words || words.length === 0) {
    console.error("❌ Error fetching words:", wordError?.message);
    return new Response(
      JSON.stringify({ error: "Failed to fetch words from database" }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  // Select a random word for the notification
  const randomWord = words[Math.floor(Math.random() * words.length)];

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
    `🔔 Sending new word notifications to ${onesignalIds.length} users`,
  );
  console.log(`📚 Selected word: ${randomWord.word}`);

  // Use the word as the title and definition as the message
  const title = randomWord.word || "New Word";
  const message = randomWord.definition || "Learn a new word today!";

  // Random time between 9 AM and 9 PM for delivery
  // Format: "H:MMAM" or "HH:MMAM" (e.g., "9:00AM", "2:30PM")
  // OneSignal expects format like "9:00AM" or "2:30PM"
  const startHour = 9;
  const endHour = 21;
  const randomHour = startHour + Math.floor(Math.random() * (endHour - startHour + 1));
  const randomMinute = Math.floor(Math.random() * 60);
  const hour12 = randomHour > 12 ? randomHour - 12 : randomHour === 0 ? 12 : randomHour;
  const amPm = randomHour < 12 ? "AM" : "PM";
  const deliveryTime = `${hour12}:${randomMinute.toString().padStart(2, "0")}${amPm}`;

  const notificationPayload = {
    app_id: ONE_SIGNAL_APP_ID,
    included_segments: ["All"],
    delayed_option: "timezone",
    delivery_time_of_day: deliveryTime,
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
      console.log("🔔 New word notifications sent successfully:", result);
    }

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("❌ Network or unexpected error:", err);
    return new Response(
      JSON.stringify({
        error: "Failed to send new word notifications",
        err,
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      },
    );
  }
});

