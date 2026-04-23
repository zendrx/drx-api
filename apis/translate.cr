require "crest"
require "json"

module Api
  class Translate
    getter word : String, from : String, to : String

    def initialize(@word : String, @from : String, @to : String)
    end

    
    def self.run(word, from, to)
      new(word, from, to).start_translating
    end

    def start_translating
      encoded_word = URI.encode_path(@word)
      url = "https://lingva.ml/api/v1/#{@from}/#{@to}/#{encoded_word}"

      begin
        response = Crest.get(url)
        
        if response.success?
          data = JSON.parse(response.body)
          return {
            "success"       => "true",
            "original_lang" => @from,
            "translated_to" => @to,
            "translation"   => data["translation"].as_s,
            "attribution"   => "drx_api"
          }
        end
        
        {"success" => "false", "error" => "Unknown error"}
      rescue e : Crest::RequestFailed 
        {
          "success" => "false",
          "error"   => e.message || "Request failed"
        }
      rescue e : Exception # Catch-all for network timeouts, etc.
        {
          "success" => "false",
          "error"   => e.message || "Internal Error"
        }
      end
    end
  end
end
