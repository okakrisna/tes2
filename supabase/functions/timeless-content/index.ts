import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const url = new URL(req.url);
    const path = url.pathname;

    // GET - Read content
    if (req.method === "GET") {
      // Read from Supabase storage or database
      const { createClient } = await import("npm:@supabase/supabase-js@2");
      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
      const supabase = createClient(supabaseUrl, supabaseKey);

      // Try to get from database first
      const { data: dbData, error: dbError } = await supabase
        .from("timeless_content")
        .select("*")
        .maybeSingle();

      if (!dbError && dbData) {
        return new Response(JSON.stringify({ data: dbData }), {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        });
      }

      // Fallback: return empty data
      return new Response(JSON.stringify({ data: null }), {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      });
    }

    // POST/PUT - Save content
    if (req.method === "POST" || req.method === "PUT") {
      const contentData = await req.json();
      
      const { createClient } = await import("npm:@supabase/supabase-js@2");
      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
      const supabase = createClient(supabaseUrl, supabaseKey);

      // Check if record exists
      const { data: existing } = await supabase
        .from("timeless_content")
        .select("id")
        .maybeSingle();

      let result;
      if (existing) {
        // Update existing record
        result = await supabase
          .from("timeless_content")
          .update(contentData)
          .eq("id", existing.id)
          .select()
          .single();
      } else {
        // Insert new record
        result = await supabase
          .from("timeless_content")
          .insert([contentData])
          .select()
          .single();
      }

      if (result.error) {
        throw result.error;
      }

      return new Response(JSON.stringify({ success: true, data: result.data }), {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      });
    }

    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
    });
  }
});