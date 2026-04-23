require "base64"
require "random"

 module Api
  class Base64toimg
    def self.run(base64_data : String)
      clean_data = base64_data.includes?(",") ? base64_data.split(",")[1] : base64_data

      begin 
       img_bytes = Base64.decode(clean_data)
       filename = "img_#{Random::Secure.hex(4)}.png"
       folder = "temp/img"
       filepath = File.join(folder, filename)
       File.write(filepath, img_bytes)
       {
        "success" => "true",
        "url" => "/uploads/#{filename}",
        "size" => "#{img_bytes.size} bytes",
        "message" => "will be deleted in 5 mins",
        "attribution" => "drx_api"
      }
     rescue e : Exception
       {
        "success" => "false",
        "error" => "#{e.message}"
      }
     end 
   end 
 end 
end 

        
      
        
        
      
      
      
       
       
