// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

console.log("Hello from Functions!");

interface NotificationPayload {
  userId: string;
  message: string;
  title: string;
}

Deno.serve(async (req) => {
  try {
    const { userId, message, title }: NotificationPayload = await req.json();

    const response = await fetch("https://onesignal.com/api/v1/notifications", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Basic ${Deno.env.get("ONESIGNAL_REST_API_KEY")}`,
      },
      body: JSON.stringify({
        app_id: Deno.env.get("ONESIGNAL_APP_ID"),
        include_external_user_ids: [userId],
        contents: { en: message },
        headings: { en: title },
      }),
    });

    if (!response.ok) {
      throw new Error(`OneSignal API error: ${response.statusText}`);
    }

    const result = await response.json();
    return new Response(
      JSON.stringify({ success: true, data: result }),
      { headers: { "Content-Type": "application/json" } },
    );
  } catch (error) {
    const errorMessage = error instanceof Error
      ? error.message
      : "Unknown error";
    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      {
        headers: { "Content-Type": "application/json" },
        status: 400,
      },
    );
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/notifyUser' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
