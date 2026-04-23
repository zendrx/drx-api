require "crest"
require "json"

module Api
  alias NewsItem = Hash(String, String | Nil)

  class NewsCached
    @@cache = [] of NewsItem

    def self.cache
      @@cache
    end

    def self.fetch_all
      puts "--- Refreshing News Cache: #{Time.local} ---"
      begin
        hn = fetch_hacker_news(10)
        dt = fetch_dev_to("programming", 10)
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
        begin
          res = Crest.get("https://hacker-news.firebaseio.com/v0/item/#{id}.json")
          item = JSON.parse(res.body)
          
          item_hash = { 
            "title" => item["title"].as_s, 
            "url" => item["url"]?.try(&.as_s), 
            "source" => "HackerNews" 
          } of String => String | Nil 
          
          stories << item_hash
        rescue
          next
        end
      end
      stories
    end

    private def self.fetch_dev_to(tag, limit)
      res = Crest.get("https://dev.to/api/articles?tag=#{tag}&per_page=#{limit}")
      JSON.parse(res.body).as_a.map do |a|
        { 
          "title" => a["title"].as_s, 
          "url" => a["url"].as_s, 
          "source" => "Dev.to" 
        } of String => String | Nil
      end
    end
  end
end
