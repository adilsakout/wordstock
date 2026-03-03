import { createClient } from "jsr:@supabase/supabase-js";

interface NotificationData {
  user_id: string;
  onesignal_id: string;
  notification_type: "daily_reminder" | "practice_reminder" | "new_word" | "streak_reminder";
  word: string | null;
  definition: string | null;
  scheduled_at: string;
}

// Fisher-Yates Shuffle
function shuffleArray<T>(array: T[]): T[] {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

/**
 * Returns the UTC offset in minutes for a given timezone at a given date.
 * Positive = east of UTC (e.g., Asia/Taipei UTC+8 → 480).
 * Negative = west of UTC (e.g., America/New_York UTC-5 → -300).
 */
function getUTCOffsetMinutes(timezone: string, date: Date): number {
  try {
    const fmt = new Intl.DateTimeFormat("en", {
      timeZone: timezone,
      timeZoneName: "shortOffset",
    });
    const parts = fmt.formatToParts(date);
    const offsetStr = parts.find((p) => p.type === "timeZoneName")?.value ?? "GMT+0";
    // Matches "GMT+8", "GMT-5", "GMT+5:30", "GMT"
    const match = offsetStr.match(/^GMT([+-])(\d{1,2})(?::(\d{2}))?$/);
    if (!match) return 0;
    const sign = match[1] === "+" ? 1 : -1;
    const hours = parseInt(match[2], 10);
    const mins = parseInt(match[3] ?? "0", 10);
    return sign * (hours * 60 + mins);
  } catch {
    return 0; // fall back to UTC
  }
}

/**
 * Returns a UTC Date that corresponds to `localHour:localMinute` in the
 * user's timezone on the same calendar day the user currently experiences.
 */
function getScheduledUTCTime(
  timezone: string,
  localHour: number,
  localMinute: number,
  now: Date,
): Date {
  // Get user's current local date as YYYY-MM-DD
  const localDateStr = new Intl.DateTimeFormat("en-CA", {
    timeZone: timezone,
  }).format(now); // e.g., "2026-03-02"

  const offsetMinutes = getUTCOffsetMinutes(timezone, now);

  // Treat the desired local time as a naive UTC timestamp, then subtract the offset
  // Example: user in UTC+8 wants 9 AM → naiveUTC = 09:00Z → result = 01:00Z ✓
  const naiveUTC = new Date(
    `${localDateStr}T${String(localHour).padStart(2, "0")}:${
      String(localMinute).padStart(2, "0")
    }:00.000Z`,
  );
  return new Date(naiveUTC.getTime() - offsetMinutes * 60_000);
}

/**
 * Returns "YYYY-MM-DD" for a given date in the specified timezone.
 */
function getLocalDateStr(timezone: string, date: Date): string {
  return new Intl.DateTimeFormat("en-CA", { timeZone: timezone }).format(date);
}

const CHUNK_SIZE = 500;

Deno.serve(async () => {
  console.log("🚀 Starting word scheduling function");

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // 1. Fetch all users with OneSignal ID and notifications enabled (1 query)
  console.log("🔍 Fetching users with OneSignal ID and notifications enabled");
  const { data: users, error: userError } = await supabase
    .from("user_profiles")
    .select(`
      user_id,
      onesignal_id,
      words_per_day,
      notifications_enabled,
      daily_reminder_enabled,
      practice_reminder_enabled,
      new_word_notification_enabled,
      streak_reminder_enabled,
      daily_streak,
      last_active_date,
      time_zone
    `)
    .not("onesignal_id", "is", null)
    .eq("notifications_enabled", true);

  if (userError || !users) {
    console.error("❌ Error fetching users:", userError?.message);
    return new Response("Error fetching users", { status: 500 });
  }

  console.log(`📊 Found ${users.length} users with notifications enabled`);

  if (users.length === 0) {
    console.log("✨ No users to schedule — done");
    return new Response("✅ No users to schedule", { status: 200 });
  }

  // 2. Fetch word pool once and reuse (1 query)
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
  console.log(`📅 Scheduling notifications for: ${now.toISOString()}`);

  // 3. Bulk DELETE existing notifications for all users in a single time window.
  // Window: now-16h → now+40h covers all timezones (UTC-12 to UTC+14)
  // and all notification times (9 AM earliest, 8 PM latest local).
  const windowStart = new Date(now.getTime() - 16 * 60 * 60 * 1000);
  const windowEnd = new Date(now.getTime() + 40 * 60 * 60 * 1000);
  const userIds = users.map((u) => u.user_id);

  console.log(`🗑️  Bulk deleting existing notifications in window ${windowStart.toISOString()} → ${windowEnd.toISOString()}`);

  for (let i = 0; i < userIds.length; i += CHUNK_SIZE) {
    const chunk = userIds.slice(i, i + CHUNK_SIZE);
    const { error: deleteError } = await supabase
      .from("word_notifications")
      .delete()
      .in("user_id", chunk)
      .gte("scheduled_at", windowStart.toISOString())
      .lte("scheduled_at", windowEnd.toISOString());

    if (deleteError) {
      console.error(`❌ Bulk delete error (chunk ${i / CHUNK_SIZE + 1}):`, deleteError.message);
    }
  }

  // 4. Build all notifications in memory — zero DB calls per user
  const allNotifications: NotificationData[] = [];

  for (const user of users) {
    const {
      user_id: userId,
      onesignal_id,
      daily_reminder_enabled,
      practice_reminder_enabled,
      new_word_notification_enabled,
      streak_reminder_enabled,
      daily_streak,
      last_active_date,
      time_zone,
    } = user;

    const tz = time_zone || "UTC";
    const userLocalToday = getLocalDateStr(tz, now);

    // Daily Reminder — 9 AM in user's local timezone
    if (daily_reminder_enabled) {
      const scheduled = getScheduledUTCTime(tz, 9, 0, now);
      allNotifications.push({
        user_id: userId,
        onesignal_id,
        notification_type: "daily_reminder",
        word: null,
        definition: null,
        scheduled_at: scheduled.toISOString(),
      });
    }

    // Practice Reminder — 6 PM in user's local timezone
    // Send if user hasn't been active for 24+ hours OR has never been active
    if (practice_reminder_enabled) {
      const shouldSend = !last_active_date ||
        (now.getTime() - new Date(last_active_date).getTime()) / (1000 * 60 * 60) >= 24;

      if (shouldSend) {
        const scheduled = getScheduledUTCTime(tz, 18, 0, now);
        allNotifications.push({
          user_id: userId,
          onesignal_id,
          notification_type: "practice_reminder",
          word: null,
          definition: null,
          scheduled_at: scheduled.toISOString(),
        });
      }
    }

    // New Word Notification — random time 9 AM–8 PM in user's local timezone
    if (new_word_notification_enabled) {
      const randomHour = 9 + Math.floor(Math.random() * 12); // 9–20
      const randomMinute = Math.floor(Math.random() * 60);
      const selectedWord = shuffleArray(allWords)[0] as { word: string; definition: string };
      const scheduled = getScheduledUTCTime(tz, randomHour, randomMinute, now);
      allNotifications.push({
        user_id: userId,
        onesignal_id,
        notification_type: "new_word",
        word: selectedWord.word,
        definition: selectedWord.definition,
        scheduled_at: scheduled.toISOString(),
      });
    }

    // Streak Reminder — 8 PM in user's local timezone (only if streak is at risk)
    if (streak_reminder_enabled && daily_streak && daily_streak > 0) {
      const lastActive = last_active_date ? new Date(last_active_date) : null;
      const isActiveToday = lastActive &&
        getLocalDateStr(tz, lastActive) === userLocalToday;

      if (!isActiveToday) {
        const scheduled = getScheduledUTCTime(tz, 20, 0, now);
        allNotifications.push({
          user_id: userId,
          onesignal_id,
          notification_type: "streak_reminder",
          word: null,
          definition: null,
          scheduled_at: scheduled.toISOString(),
        });
      }
    }
  }

  console.log(`📬 Built ${allNotifications.length} notifications for ${users.length} users`);

  // 5. Batch INSERT all notifications (1 query per 500 rows)
  let inserted = 0;
  for (let i = 0; i < allNotifications.length; i += CHUNK_SIZE) {
    const chunk = allNotifications.slice(i, i + CHUNK_SIZE);
    const { error: insertError } = await supabase
      .from("word_notifications")
      .insert(chunk);

    if (insertError) {
      console.error(`❌ Batch insert error (chunk ${i / CHUNK_SIZE + 1}):`, insertError.message);
    } else {
      inserted += chunk.length;
    }
  }

  console.log(`✨ Scheduling complete — inserted ${inserted} notifications`);
  return new Response(`✅ Scheduled ${inserted} notifications for ${users.length} users`, { status: 200 });
});
