require "crest"
require "json"

module Api
   type NewsItem = Hash(String, String | Nil)
   @@cache = [] of NewsItem
  class NewsCached
    # This is our in-memory storage
    
    # Getter to let the Kemal route see the cache
    def self.cache
      @@cache
    end

    def self.fetch_all
      puts "--- Refreshing News Cache: #{Time.local} ---"
      begin
        hn = fetch_hacker_news(10)
        dt = fetch_dev_to("programming", 10)
        
        # Overwrite the old cache with the new data
        @@cache = (hn + dt).shuffle
      rescue e : Exception
        puts "Cache refresh failed: #{e.message}"
      end
    end

    private def self.fetch_hacker_news(limit)
      ids_res = Crest.get("https://hacker-news.firebaseio.com/v0/topstories.json")
      ids = JSON.parse(ids_res.body).as_a.first(limit)
      
      stories = [] of NewsItem
      ids.each do |id|
      item_hash = { 
       "title" => item["title"].as_s, 
       "url" => item["url"]?.try(&.as_s), 
       "source" => "HackerNews" 
      } of String => String | Nil 
    
      stories << item_hash
    end
    stories
   end

    private def self.fetch_dev_to(tag, limit)
      res = Crest.get("https://dev.to/api/articles?tag=#{tag}&per_page=#{limit}")
      JSON.parse(res.body).as_a.map do |a|
        { "title" => a["title"].as_s, "url" => a["url"].as_s, "source" => "Dev.to" } of String => String | Nil
      end
    end
  end
end
