import { createClient } from "jsr:@supabase/supabase-js";

// Interface for notification data before insertion
interface NotificationData {
  user_id: string;
  onesignal_id: string;
  notification_type: 'daily_reminder' | 'practice_reminder' | 'new_word' | 'streak_reminder';
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

Deno.serve(async () => {
  console.log("🚀 Starting word scheduling function");

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // 1. Fetch all users with OneSignal ID and notifications enabled
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
  console.log(`📅 Scheduling notifications for today: ${today.toISOString()}`);

  // Process each user for all notification types
  for (const user of users) {
    const { 
      user_id: userId, 
      onesignal_id, 
      daily_reminder_enabled,
      practice_reminder_enabled,
      new_word_notification_enabled,
      streak_reminder_enabled,
      daily_streak,
      last_active_date    } = user;
    
    console.log(`\n👤 Processing user ${userId}`);
    
    // 🚨 CRITICAL FIX: Check if notifications already exist for today to prevent duplicates
    const todayStart = new Date(today);
    todayStart.setHours(0, 0, 0, 0);
    const todayEnd = new Date(today);
    todayEnd.setHours(23, 59, 59, 999);
    
    console.log(`🔍 Checking for existing notifications for user ${userId} on ${today.toDateString()}`);
    const { data: existingNotifications, error: checkError } = await supabase
      .from("word_notifications")
      .select("notification_type")
      .eq("user_id", userId)
      .gte("scheduled_at", todayStart.toISOString())
      .lte("scheduled_at", todayEnd.toISOString());
    
    if (checkError) {
      console.error(`❌ Error checking existing notifications for user ${userId}:`, checkError.message);
      continue; // Skip this user but continue with others
    }
    
    const existingTypes = new Set(existingNotifications?.map((n: { notification_type: string }) => n.notification_type) || []);
    
    if (existingTypes.size > 0) {
      console.log(`⚠️  Found ${existingTypes.size} existing notifications for user ${userId}: [${Array.from(existingTypes).join(', ')}]`);
      console.log(`🧹 Deleting existing notifications to prevent duplicates...`);
      
      // Delete existing notifications for today to prevent duplicates
      const { error: deleteError } = await supabase
        .from("word_notifications")
        .delete()
        .eq("user_id", userId)
        .gte("scheduled_at", todayStart.toISOString())
        .lte("scheduled_at", todayEnd.toISOString());
        
      if (deleteError) {
        console.error(`❌ Error deleting existing notifications for user ${userId}:`, deleteError.message);
        continue; // Skip this user but continue with others
      } else {
        console.log(`✅ Successfully deleted existing notifications for user ${userId}`);
      }
    } else {
      console.log(`✅ No existing notifications found for user ${userId} - proceeding with scheduling`);
    }
    
    const allNotifications: NotificationData[] = [];

    // 1. Schedule Daily Reminder (once per day at 9 AM)
    if (daily_reminder_enabled) {
      console.log(`📅 Scheduling daily reminder for user ${userId}`);
      const dailyReminderTime = new Date(today);
      dailyReminderTime.setHours(9, 0, 0, 0); // 9 AM
      
      allNotifications.push({
        user_id: userId,
        onesignal_id,
        notification_type: 'daily_reminder',
        word: null,
        definition: null,
        scheduled_at: dailyReminderTime.toISOString(),
      });
    }

    // 2. Schedule Practice Reminder (if user hasn't been active)
    if (practice_reminder_enabled && last_active_date) {
      const lastActive = new Date(last_active_date);
      const hoursSinceActive = (now.getTime() - lastActive.getTime()) / (1000 * 60 * 60);
      
      // Schedule practice reminder if user hasn't been active for 24+ hours
      if (hoursSinceActive >= 24) {
        console.log(`🏃 Scheduling practice reminder for user ${userId} (${hoursSinceActive.toFixed(1)} hours inactive)`);
        const practiceReminderTime = new Date(today);
        practiceReminderTime.setHours(18, 0, 0, 0); // 6 PM
        
        allNotifications.push({
          user_id: userId,
          onesignal_id,
          notification_type: 'practice_reminder',
          word: null,
          definition: null,
          scheduled_at: practiceReminderTime.toISOString(),
        });
      }
    }

    // 3. Schedule New Word Notification (one per day at random time between 9 AM - 9 PM)
    if (new_word_notification_enabled) {
      console.log(`📚 Scheduling one new word notification for user ${userId}`);
      
      // Select one random word for this user
      const selectedWord = shuffleArray(allWords)[0] as { word: string; definition: string };
      
      // Random time between 9 AM and 9 PM
      const startHour = 9;
      const endHour = 21;
      const randomHour = startHour + Math.floor(Math.random() * (endHour - startHour));
      const randomMinute = Math.floor(Math.random() * 60);
      
      const scheduled = new Date(today);
      scheduled.setHours(randomHour, randomMinute, 0, 0);
      
      allNotifications.push({
        user_id: userId,
        onesignal_id,
        notification_type: 'new_word',
        word: selectedWord.word,
        definition: selectedWord.definition,
        scheduled_at: scheduled.toISOString(),
      });
    }

    // 4. Schedule Streak Reminder (if streak is at risk)
    if (streak_reminder_enabled && daily_streak && daily_streak > 0) {
      // Check if user needs a streak reminder (hasn't been active today)
      const lastActive = last_active_date ? new Date(last_active_date) : null;
      const isActiveToday = lastActive && 
        lastActive.toDateString() === today.toDateString();
      
      if (!isActiveToday) {
        console.log(`🔥 Scheduling streak reminder for user ${userId} (${daily_streak} day streak at risk)`);
        const streakReminderTime = new Date(today);
        streakReminderTime.setHours(20, 0, 0, 0); // 8 PM
        
        allNotifications.push({
          user_id: userId,
          onesignal_id,
          notification_type: 'streak_reminder',
          word: null,
          definition: null,
          scheduled_at: streakReminderTime.toISOString(),
        });
      }
    }

    // Insert all notifications for this user (duplicate-safe)
    if (allNotifications.length > 0) {
      console.log(`💾 Inserting ${allNotifications.length} fresh notifications for user ${userId} (duplicates prevented)`);
      const { error: insertError } = await supabase
        .from("word_notifications")
        .insert(allNotifications);

      if (insertError) {
        console.error(`❌ Insert error for user ${userId}:`, insertError.message);
      } else {
        const notificationTypes = allNotifications.map(n => n.notification_type).join(', ');
        console.log(`✅ Successfully scheduled ${allNotifications.length} notifications for user ${userId}: [${notificationTypes}]`);
      }
    } else {
      console.log(`⏩ No notifications to schedule for user ${userId}`);
    }
  }

  console.log("✨ All notification types scheduled successfully with duplicate prevention");
  return new Response("✅ All notification types scheduled (duplicates prevented)", { status: 200 });
});
