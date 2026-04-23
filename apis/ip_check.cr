require "crest"
require "json"

module Api
  class IpCheck
    def self.run(ip_address : String)
      url = "http://ip-api.com/json/#{ip_address}?fields=status,message,country,countryCode,regionName,city,zip,isp,org,as,query"

      begin
        response = Crest.get(url)
        
        if response.success?
          data = JSON.parse(response.body)
          
          if data["status"] == "success"
            {
              "success"     => "true",
              "ip"          => data["query"].as_s,
              "location"    => "#{data["city"]}, #{data["country"]}",
              "country_code" => data["countryCode"].as_s,
              "isp"         => data["isp"].as_s,
              "zip"         => data["zip"].as_s,
              "attribution" => "drx_api"
            }
          else
            {"success" => "false", "error" => data["message"].to_s}
          end
        else
          {"success" => "false", "error" => "External service down"}
        end
      rescue e : Exception
        {"success" => "false", "error" => e.message.to_s}
      end
    end
  end
end
