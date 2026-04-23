require "base64"
require "random"
require "file_utils"

module Api
  class Base64toimg
    def self.run(base64_data : String)
      # 1. Clean the string
      clean_data = base64_data.includes?(",") ? base64_data.split(",")[1] : base64_data
      
      # 2. Setup paths
      # Note: We save into 'public/temp' so Kemal can serve it easily
      folder = "public/temp/img"
      Dir.mkdir_p(folder) unless Dir.exists?(folder)

      begin 
        img_bytes = Base64.decode(clean_data)
        filename = "img_#{Random::Secure.hex(4)}.png"
        filepath = File.join(folder, filename)
        
        # 3. Write the file
        File.write(filepath, img_bytes)

        # 4. The Janitor (Deletes the file in 5 minutes)
        spawn do
          sleep 5.minutes
          File.delete(filepath) if File.exists?(filepath)
        end

        {
          "success"     => "true",
          "url"         => "/temp/img/#{filename}", # Public URL for the browser
          "size"        => "#{img_bytes.size} bytes",
          "message"     => "will be deleted in 5 mins",
          "attribution" => "drx_api"
        }
      rescue e : Exception
        {
          "success" => "false",
          "error"   => e.message.to_s
        }
      end 
    end 
  end 
end
