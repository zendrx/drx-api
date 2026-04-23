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

get "api/qr/:text" do |env|
  text = env.params.url["text"].as(String)
  qr = Api::Qrcode.run(text)
  qr.to_json
end 

post "/api/scrape" do |env|
 url = env.params.json["url"].as(String)
 selector = env.params.json["selector"].as(String)
 scraped = Api::Scraper.run(url, selector)
 scraped.to_json
end 

post "/api/stress-test" do |env|
 url = env.params.json["url"].as(String)
 count = env.params.json["count"].as(String)
 test = Api::StressTest.run(url, count)
 test.to_json
end 

post "/api/translate" do |env|
 word = env.params.json["word"].as(String)
 to = env.params.json["to"].as(String)
 from = env.params.json["from"].as(String)
 translate = Api::Translate.run(word, from, to)
 translate.to_json
end 

post "/api/validate/email" do |env|
 email = env.params.json["email"].as(String)
 validate = Api::Validate.email(email)
 validate.to_json
end 

post "/api/validate/number" do |env|
 number = env.params.json["number"].as(String)
 validate = Api::Validate.phone(number)
 validate.to_json
end 

kemal.run
puts "drx started...."
 






 


  







  
  
  
 
 
