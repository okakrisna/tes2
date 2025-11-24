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
      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

      // Use REST API directly instead of JS client
      const response = await fetch(`${supabaseUrl}/rest/v1/timeless_content?select=*&limit=1`, {
        headers: {
          'Authorization': `Bearer ${supabaseKey}`,
          'apikey': supabaseKey,
          'Content-Type': 'application/json'
        }
      });

      if (response.ok) {
        const results = await response.json();
        const data = results.length > 0 ? results[0] : null;
        return new Response(JSON.stringify({ data }), {
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

      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

      // Check if record exists using REST API
      const checkResponse = await fetch(`${supabaseUrl}/rest/v1/timeless_content?select=id&limit=1`, {
        headers: {
          'Authorization': `Bearer ${supabaseKey}`,
          'apikey': supabaseKey,
          'Content-Type': 'application/json'
        }
      });

      const existing = await checkResponse.json();
      let result;

      if (existing && existing.length > 0) {
        // Update existing record
        const updateResponse = await fetch(`${supabaseUrl}/rest/v1/timeless_content?id=eq.${existing[0].id}`, {
          method: 'PATCH',
          headers: {
            'Authorization': `Bearer ${supabaseKey}`,
            'apikey': supabaseKey,
            'Content-Type': 'application/json',
            'Prefer': 'return=representation'
          },
          body: JSON.stringify(contentData)
        });

        if (!updateResponse.ok) {
          const error = await updateResponse.text();
          throw new Error(`Update failed: ${error}`);
        }

        result = await updateResponse.json();
      } else {
        // Insert new record
        const insertResponse = await fetch(`${supabaseUrl}/rest/v1/timeless_content`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${supabaseKey}`,
            'apikey': supabaseKey,
            'Content-Type': 'application/json',
            'Prefer': 'return=representation'
          },
          body: JSON.stringify(contentData)
        });

        if (!insertResponse.ok) {
          const error = await insertResponse.text();
          throw new Error(`Insert failed: ${error}`);
        }

        result = await insertResponse.json();
      }

      return new Response(JSON.stringify({ success: true, data: result[0] || result }), {
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