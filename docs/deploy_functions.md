# Deploying Supabase Edge Functions

This guide explains how to deploy the notification functions to your Supabase project.

## Prerequisites

1. **Supabase CLI installed**
   ```bash
   npm install -g supabase
   ```

2. **Logged in to Supabase**
   ```bash
   supabase login
   ```

3. **Linked to your project**
   ```bash
   supabase link --project-ref your-project-ref
   ```
   You can find your project ref in your Supabase dashboard URL: `https://supabase.com/dashboard/project/YOUR_PROJECT_REF`

## Deployment Steps

### 1. Deploy All Functions at Once

Deploy all functions to your Supabase project:

```bash
supabase functions deploy
```

This will deploy all functions in the `supabase/functions` directory.

### 2. Deploy Individual Functions

If you want to deploy specific functions one at a time:

```bash
# Deploy daily reminder function
supabase functions deploy dailyReminder

# Deploy practice reminder function
supabase functions deploy practiceReminder

# Deploy new word notification function
supabase functions deploy newWordNotification

# Deploy streak reminder function
supabase functions deploy streakReminder
```

### 3. Set Environment Variables

Make sure your Supabase project has the required environment variables set:

```bash
# Set OneSignal credentials
supabase secrets set ONESIGNAL_APP_ID=your_onesignal_app_id
supabase secrets set ONESIGNAL_API_KEY=your_onesignal_api_key
```

These secrets are automatically available to all Edge Functions.

### 4. Verify Deployment

After deployment, you can verify your functions are live:

```bash
# List all deployed functions
supabase functions list
```

## Setting Up Scheduled Functions

After deploying, you need to set up cron jobs or scheduled invocations for each function:

### Option 1: Using Supabase Dashboard

1. Go to your Supabase Dashboard
2. Navigate to **Database** → **Cron Jobs** (or **Edge Functions** → **Cron Jobs**)
3. Create new cron jobs for each function:

   - **Daily Reminder**: Run daily at 9:00 AM
     - Function: `dailyReminder`
     - Schedule: `0 9 * * *` (cron format)

   - **Practice Reminder**: Run daily at 6:00 PM
     - Function: `practiceReminder`
     - Schedule: `0 18 * * *` (cron format)

   - **New Word Notification**: Run daily at a random time (or specific time)
     - Function: `newWordNotification`
     - Schedule: `0 12 * * *` (example: 12:00 PM daily)

   - **Streak Reminder**: Run daily at 8:00 PM
     - Function: `streakReminder`
     - Schedule: `0 20 * * *` (cron format)

### Option 2: Using pg_cron (PostgreSQL Extension)

If you have pg_cron enabled, you can create cron jobs directly in SQL:

```sql
-- Daily Reminder at 9:00 AM
SELECT cron.schedule(
  'daily-reminder',
  '0 9 * * *',
  $$
  SELECT net.http_post(
    url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/dailyReminder',
    headers := '{"Authorization": "Bearer YOUR_ANON_KEY"}'::jsonb
  );
  $$
);

-- Practice Reminder at 6:00 PM
SELECT cron.schedule(
  'practice-reminder',
  '0 18 * * *',
  $$
  SELECT net.http_post(
    url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/practiceReminder',
    headers := '{"Authorization": "Bearer YOUR_ANON_KEY"}'::jsonb
  );
  $$
);

-- New Word Notification at 12:00 PM
SELECT cron.schedule(
  'new-word-notification',
  '0 12 * * *',
  $$
  SELECT net.http_post(
    url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/newWordNotification',
    headers := '{"Authorization": "Bearer YOUR_ANON_KEY"}'::jsonb
  );
  $$
);

-- Streak Reminder at 8:00 PM
SELECT cron.schedule(
  'streak-reminder',
  '0 20 * * *',
  $$
  SELECT net.http_post(
    url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/streakReminder',
    headers := '{"Authorization": "Bearer YOUR_ANON_KEY"}'::jsonb
  );
  $$
);
```

### Option 3: Using External Cron Service

You can also use external services like:
- **GitHub Actions** (for free scheduled tasks)
- **Vercel Cron** (if using Vercel)
- **AWS EventBridge** (for AWS deployments)
- **Google Cloud Scheduler** (for GCP deployments)

Example GitHub Actions workflow:

```yaml
name: Daily Notifications

on:
  schedule:
    - cron: '0 9 * * *'  # 9 AM UTC daily

jobs:
  daily-reminder:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Daily Reminder
        run: |
          curl -X POST \
            -H "Authorization: Bearer ${{ secrets.SUPABASE_ANON_KEY }}" \
            https://YOUR_PROJECT_REF.supabase.co/functions/v1/dailyReminder
```

## Testing Functions Locally

Before deploying, you can test functions locally:

```bash
# Start local Supabase
supabase start

# Serve functions locally
supabase functions serve

# Test a specific function
curl -X POST http://localhost:54321/functions/v1/dailyReminder \
  -H "Authorization: Bearer YOUR_ANON_KEY"
```

## Monitoring and Logs

View function logs:

```bash
# View logs for a specific function
supabase functions logs dailyReminder

# View logs for all functions
supabase functions logs
```

Or view logs in the Supabase Dashboard:
1. Go to **Edge Functions**
2. Click on a function name
3. View the **Logs** tab

## Troubleshooting

### Function Not Deploying

1. Check that you're in the correct directory (project root)
2. Verify your `config.toml` has the function configuration
3. Ensure you're logged in: `supabase login`
4. Check that your project is linked: `supabase link`

### Function Errors

1. Check function logs: `supabase functions logs <function-name>`
2. Verify environment variables are set: `supabase secrets list`
3. Test locally first before deploying

### Scheduled Functions Not Running

1. Verify cron jobs are set up correctly
2. Check cron job logs in Supabase Dashboard
3. Ensure function URLs are correct
4. Verify authentication headers are set properly

## Function URLs

After deployment, your functions will be available at:

```
https://YOUR_PROJECT_REF.supabase.co/functions/v1/dailyReminder
https://YOUR_PROJECT_REF.supabase.co/functions/v1/practiceReminder
https://YOUR_PROJECT_REF.supabase.co/functions/v1/newWordNotification
https://YOUR_PROJECT_REF.supabase.co/functions/v1/streakReminder
```

Replace `YOUR_PROJECT_REF` with your actual Supabase project reference.

