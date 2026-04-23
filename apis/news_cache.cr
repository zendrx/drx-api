require "crest"
require "json"

module Api
  class NewsCached
    # This is our in-memory storage
    @@cache = [] of Hash(String, String?)
    
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
      
      stories = [] of Hash(String, String?)
      ids.each do |id|
        res = Crest.get("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
        item = JSON.parse(res.body)
        stories << { "title" => item["title"].as_s, "url" => item["url"]?.try(&.as_s), "source" => "HackerNews" }
      end
      stories
    end

    private def self.fetch_dev_to(tag, limit)
      res = Crest.get("https://dev.to/api/articles?tag=#{tag}&per_page=#{limit}")
      JSON.parse(res.body).as_a.map do |a|
        { "title" => a["title"].as_s, "url" => a["url"].as_s, "source" => "Dev.to" }
      end
    end
  end
end
