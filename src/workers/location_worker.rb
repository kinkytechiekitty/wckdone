require 'net/http'
require 'sidekiq'

class LocationWorker
  include Sidekiq::Worker

  def perform(user_id, ip)
    user = User.find(id: user_id)
    return if user.nil?
    logger.info("Looking up #{ip}")
    url = URI.parse("https://api.ipstack.com/#{ip}" +
                    "?access_key=#{ENV[IPSTACK_KEY]}")
    req = Net::HTTP::Get.new(url.to_s)
    http = res = Net::HTTP.start(url.host, url.port, use_ssl: true){ |http|
      http.request(req)
    }
    logger.info("Response: #{res.inspect}")
    location = JSON.parse(res.body)
    logger.info(location)
    user.set_location(location)
  end
end
