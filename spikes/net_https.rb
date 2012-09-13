require "net/http"

uri = URI('https://mes-courses-integ.heroku.com/dishes')
Net::HTTP.start(uri.host, uri.port, use_ssl: true).start do |http|
  request = Net::HTTP::Get.new uri.request_uri
  response = http.request request

  puts response.code

end
