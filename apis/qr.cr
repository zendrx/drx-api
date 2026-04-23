require "qr_code"

 module Api
  class Qrcode
     def self.run(text : String)
      begin  
       qr = QRCode.new(text)
       svg_data = qr.as_svg(fill : "000", output_unit : "px")
       {
        "success" => "true",
        "data" => svg_data,
        "attribution" => "drx_api"
       }
     rescue e : Exception
      {
        "success" => "false"
        "error" => "#{e.message}"
      }
     end 
   end 
 end 
end 

      
        
        
      
