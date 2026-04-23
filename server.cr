require "kemal"
require "./apis/*"

spawn do
  loop do
    Api::NewsCached.fetch_all
    sleep 60.minutes
  end
end

before_all do |env|
  env.response.headers["Access-Control-Allow-Origin"] = "*"
  env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
  env.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
end

options "*" do |env|
  env.response.status_code = 200
  ""
end

post "/api/base64-img" do |env|
  env.response.content_type = "application/json"
  base64_data = env.params.json["base64-string"].as(String)
  img = Api::Base64toimg.run(base64_data)
  img.to_json
end

post "/api/ip-check" do |env|
  env.response.content_type = "application/json"
  ip = env.params.json["ip"].as(String)
  result = Api::IpCheck.run(ip)
  result.to_json
end

post "/api/markdown-html" do |env|
  env.response.content_type = "application/json"
  md = env.params.json["content"].as(String)
  html = Api::MarkdownToHtml.run(md)
  html.to_json
end

get "/api/news" do |env|
  env.response.content_type = "application/json"
  news = Api::NewsCached.cache
  { "success" => "true", "data" => news }.to_json
end

get "/api/qr/:text" do |env|
  env.response.content_type = "application/json"
  text = env.params.url["text"].as(String)
  qr = Api::Qrcode.run(text)
  qr.to_json
end

post "/api/scrape" do |env|
  env.response.content_type = "application/json"
  url = env.params.json["url"].as(String)
  selector = env.params.json["selector"].as(String)
  scraped = Api::Scraper.run(url, selector)
  scraped.to_json
end

post "/api/stress-test" do |env|
  env.response.content_type = "application/json"
  url = env.params.json["url"].as(String)
  count = env.params.json["count"].as(Int32)
  test = Api::StressTest.run(url, count)
  test.to_json
end

post "/api/translate" do |env|
  env.response.content_type = "application/json"
  word = env.params.json["word"].as(String)
  to = env.params.json["to"].as(String)
  from = env.params.json["from"].as(String)
  translate = Api::Translate.run(word, from, to)
  translate.to_json
end

post "/api/validate/email" do |env|
  env.response.content_type = "application/json"
  email = env.params.json["email"].as(String)
  validate = Api::Validate.email(email)
  validate.to_json
end

post "/api/validate/number" do |env|
  env.response.content_type = "application/json"
  number = env.params.json["number"].as(String)
  validate = Api::Validate.phone(number)
  validate.to_json
end

puts "drx started...."
Kemal.run
