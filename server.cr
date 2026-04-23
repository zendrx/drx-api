require "kemal"
require "./apis/*"

 spawn do 
   Api::NewsCached.fetch_all
   sleep 60.minutes
end 
   
post "/api/base64-img" do |env|
  base64_data = env.params.json["base64-string"].as(String)
  img = Api::Base64toimg.run(base64_data)
  img.to_json
end 

post "/api/ip-check" do |env|
  ip = env.params.body["body"].as(String)
  result = Api::IpCheck.run(ip)
  ip.to_json
end 

post "api/markdown-html" do |env|
  md = env.params.json["content"].as(String)
  html = Api::MarkdownToHtml.run(md)
  html.to_json
end 

get "api/news" do 
  news = Api::NewsCached.cache
  news.to_json
end 

get "api/qr" do |env|
  text = env.params.body["text"].as(String)
  qr = Api::Qrcode.run(text)
  qr.to_json
end 



  







  
  
  
 
 
