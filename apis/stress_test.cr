require "crest"

module Api
  class StressTest
    def self.run(target_url : String, request_count : String)

      request_count.to_i 
      # Hard cap for safety
      count = request_count > 200 ? 200 : request_count
      
      results_channel = Channel(Int32).new
      start_time = Time.monotonic

      # Fire requests concurrently using Fibers
      count.times do
        spawn do
          begin
            response = Crest.get(target_url)
            results_channel.send(response.status_code)
          rescue
            results_channel.send(0) # 0 means the server crashed/timed out
          end
        end
      end

      # Collect results
      success_count = 0
      blocked_count = 0 # 429 Too Many Requests
      failed_count = 0

      count.times do
        status = results_channel.receive
        case status
        when 200..299 then success_count += 1
        when 429      then blocked_count += 1
        else               failed_count += 1
        end
      end

      duration = Time.monotonic - start_time

      # Rate the security/stability
      rating = case
               when blocked_count > 0 then "Excellent (Rate Limiting Active)"
               when failed_count > (count / 2) then "Poor (Server Crashed/Timed Out)"
               else "Vulnerable (No Rate Limiting Detected)"
               end

      {
        "target"       => target_url,
        "requests"     => count,
        "duration_sec" => duration.total_seconds.round(2),
        "results" => {
          "success" => success_count,
          "rate_limited" => blocked_count,
          "failed" => failed_count
        },
        "security_rating" => rating,
        "attribution" => "drx_api_stress_tool"
      }
    end
  end
end
