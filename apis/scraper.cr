require "crest"
require "lexbor"

module Api
  class Scraper
    def self.run(url : String, selector : String? = nil)
      begin
        # 1. Fetch the page
        response = Crest.get(url, headers: {
          "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) drx_api/1.0"
        })

        # 2. Parse the HTML
        parser = Lexbor::Parser.new(response.body)
        
        if selector
          # Find specific elements (like "h1" or ".price")
          results = [] of String
          parser.nodes_at_css(selector).each do |node|
            results << node.inner_text.strip
          end
          
          {
            "success" => "true",
            "mode"    => "selector",
            "data"    => results,
            "count"   => results.size
          }
        else
          # If no selector, return "Smart Clean" (just the page title and body text)
          {
            "success" => "true",
            "mode"    => "clean_text",
            "title"   => parser.nodes_at_css("title").first?.try(&.inner_text) || "No Title",
            "content" => parser.nodes_at_css("body").first?.try(&.inner_text.gsub(/\s+/, " ").strip)
          }
        end
      rescue e : Exception
        { "success" => "false", "error" => e.message.to_s }
      end
    end
  end
end
