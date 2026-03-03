import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

interface ChatRequest {
  messages: Array<{ role: string; content: string }>;
  model?: string;
  max_tokens?: number;
  temperature?: number;
  stream?: boolean;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
  if (!OPENAI_API_KEY) {
    console.error("OPENAI_API_KEY not configured");
    return new Response(
      JSON.stringify({ error: "AI service not configured" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  try {
    const body: ChatRequest = await req.json();

    if (
      !body.messages ||
      !Array.isArray(body.messages) ||
      body.messages.length === 0
    ) {
      return new Response(
        JSON.stringify({ error: "messages array is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    const useStreaming = body.stream === true;

    const openaiPayload = {
      model: body.model || "gpt-4o-mini",
      messages: body.messages,
      max_tokens: body.max_tokens || 1000,
      temperature: body.temperature ?? 0.7,
      stream: useStreaming,
    };

    const openaiRes = await fetch(OPENAI_API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify(openaiPayload),
    });

    if (!openaiRes.ok) {
      const errorBody = await openaiRes.text();
      console.error(`OpenAI API error (${openaiRes.status}):`, errorBody);
      return new Response(
        JSON.stringify({ error: "AI service error", status: openaiRes.status }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    }

    // ── NON-STREAMING (original behaviour) ──────────────────────
    if (!useStreaming) {
      const openaiData = await openaiRes.json();
      const content = openaiData?.choices?.[0]?.message?.content;

      if (!content) {
        console.error(
          "Unexpected OpenAI response:",
          JSON.stringify(openaiData),
        );
        return new Response(
          JSON.stringify({ error: "Invalid AI response format" }),
          { status: 502, headers: { "Content-Type": "application/json" } },
        );
      }

      return new Response(JSON.stringify({ content }), {
        status: 200,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Connection": "keep-alive",
        },
      });
    }

    // ── STREAMING: pipe SSE from OpenAI to the client ───────────
    const respBody = openaiRes.body;
    if (!respBody) {
      return new Response(
        JSON.stringify({ error: "No response body from AI service" }),
        { status: 502, headers: { "Content-Type": "application/json" } },
      );
    }

    const reader = respBody.getReader();
    const encoder = new TextEncoder();

    const sseStream = new ReadableStream({
      async start(controller) {
        try {
          while (true) {
            const { done, value } = await reader.read();
            if (done) {
              controller.enqueue(encoder.encode("data: [DONE]\n\n"));
              controller.close();
              break;
            }
            // Forward raw SSE chunks from OpenAI
            controller.enqueue(value);
          }
        } catch (err) {
          console.error("Streaming error:", err);
          controller.error(err);
        }
      },
      cancel() {
        reader.cancel();
      },
    });

    return new Response(sseStream, {
      status: 200,
      headers: {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
      },
    });
  } catch (err) {
    console.error("Edge function error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
