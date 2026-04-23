require "crest"
require "lexbor"

module Api
  class Scraper
    def self.run(url : String, selector : String)
      begin
        # Fetch the HTML
        response = Crest.get(url, headers: {"User-Agent" => "DRX-API-Scraper"})
        
        # Parse the HTML
        parser = Lexbor::Parser.new(response.body)
        
        # Lexbor uses .nodes(selector) to return an array of nodes
        results = parser.nodes(selector).map do |node|
          # .inner_text gets the text content of the node
          node.inner_text.strip
        end

        if results.empty?
          { "success" => "false", "message" => "No elements found for that selector" }
        else
          { "success" => "true", "count" => results.size, "data" => results }
        end
      rescue e : Exception
        { "success" => "false", "error" => "Failed to scrape: #{e.message}" }
      end
    end
  end
end
