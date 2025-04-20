import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";

// Fisher-Yates Shuffle
function shuffleArray<T>(array: T[]): T[] {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

Deno.serve(async () => {
  console.log("🚀 Starting word scheduling function");

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // 1. Fetch all users with OneSignal ID
  console.log("🔍 Fetching users with OneSignal ID");
  const { data: users, error: userError } = await supabase
    .from("user_profiles")
    .select("user_id, onesignal_id, words_per_day")
    .not("onesignal_id", "is", null);

  if (userError || !users) {
    console.error("❌ Error fetching users:", userError?.message);
    return new Response("Error fetching users", { status: 500 });
  }

  console.log(`📊 Found ${users.length} users to process`);

  // 2. Fetch 1000 words once and reuse
  console.log("📚 Fetching word pool (1000 words)");
  const { data: allWords, error: wordError } = await supabase
    .from("words")
    .select("word, definition")
    .limit(1000);

  if (wordError || !allWords || allWords.length === 0) {
    console.error("❌ Error fetching words:", wordError?.message);
    return new Response("Error fetching words", { status: 500 });
  }

  console.log(`📚 Successfully fetched ${allWords.length} words`);

  const now = new Date();
  const today = new Date(now);
  today.setHours(0, 0, 0, 0);
  console.log(`📅 Scheduling words for today: ${today.toISOString()}`);

  for (const user of users) {
    const { user_id: userId, onesignal_id, words_per_day } = user;
    console.log(`\n👤 Processing user ${userId}`);
    console.log(`📝 Words per day: ${words_per_day}`);

    if (!words_per_day || words_per_day <= 0) {
      console.log(`⚠️ Skipping user ${userId} - invalid words_per_day`);
      continue;
    }

    // Shuffle once per user to get different words
    console.log(`🎲 Shuffling words for user ${userId}`);
    const selectedWords = shuffleArray(allWords).slice(0, words_per_day);
    console.log(`✅ Selected ${selectedWords.length} words for user ${userId}`);

    // Spread evenly through the day
    const interval = Math.floor(1440 / words_per_day); // in minutes
    console.log(`⏰ Interval between words: ${interval} minutes`);

    const inserts = selectedWords.map((w, i) => {
      const scheduled = new Date(today);
      scheduled.setMinutes(i * interval + Math.floor(Math.random() * 10)); // Add slight randomness
      console.log(
        `📅 Word "${w.word}" scheduled for ${scheduled.toISOString()}`,
      );

      return {
        user_id: userId,
        onesignal_id,
        word: w.word,
        definition: w.definition,
        scheduled_at: scheduled.toISOString(),
      };
    });

    console.log(
      `💾 Inserting ${inserts.length} scheduled words for user ${userId}`,
    );
    const { error: insertError } = await supabase
      .from("word_notifications")
      .insert(inserts);

    if (insertError) {
      console.error(`❌ Insert error for user ${userId}:`, insertError.message);
    } else {
      console.log(`✅ Successfully scheduled words for user ${userId}`);
    }
  }

  console.log("✨ Word scheduling completed successfully");
  return new Response("✅ Word notifications scheduled", { status: 200 });
});
