class City < ApplicationRecord
    has_many :cuisines
    
    
    # search_result = City.fetch_info(api_key, city_name) in controller
    # https://developers.zomato.com/api/v2.1/cities?q=west%20new%20york&count=1
    def self.fetch_info(api_key, city_name)

        uri = URI.parse("https://developers.zomato.com/api/v2.1/cities?q=#{city_name}&count=1")
        request = Net::HTTP::Get.new(uri)
        request["Accept"] = "application/json"
        request["user-key"] = api_key
        req_options = {
            use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
        hash = JSON.parse(response.body)
        hash
    end
end
