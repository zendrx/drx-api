require "crest"
  module Api
   class Translate 
    def initialize(word : String, from : String, to : String)
      @word = word
      @from = from
      @to = to 
      start_translating
    end 

    def start_translating
      url = "https://lingva.ml/api/v1/#{@from}/#{@to}/#{@word}"
      begin
       response = Crest.get(url)
       if response.success?
        data = JSON.parse(response.body)
         {
          "success" => "true",
          "original_lang" => "#{@from}",
          "translated_to" => "#{@to}",
          "translation" => "#{data["translation"]}",
          "attribution" => "drx_api"
         } of String => String
      end 
     rescue e : Crest:ResquestFailed
      {
        "success" => "false"
        "error" => "#{e.message}"
     } of String => String
    end 
  end 
 end
end 
  
      
      
      
