class City < ApplicationRecord
    has_many :cuisines
    
    
    # search_result = City.fetch_info(api_key, city_name) in controller
    # https://developers.zomato.com/api/v2.1/cities?q=west%20new%20york&count=1
    def self.fetch_info(api_key, city_name)
        #return a hash, has city infomation and cuisines in that city
        result = {}
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
        city_info = JSON.parse(response.body)
        city_id = city_info["location_suggestions"][0]["id"]
        result = {:city_info => city_info["location_suggestions"][0]}
        
        cuisine_url = URI.parse("https://developers.zomato.com/api/v2.1/cuisines?city_id=#{city_id}")
        cuisine_request = Net::HTTP::Get.new(cuisine_url)
        cuisine_request["Accept"] = "application/json"
        cuisine_request["user-key"] = api_key
        cuisine_req_options = {
            use_ssl: uri.scheme == "https",
        }
        cuisine_response = Net::HTTP.start(cuisine_url.hostname, cuisine_url.port, cuisine_req_options) do |http|
            http.request(cuisine_request)
        end
        cuisines = JSON.parse(cuisine_response.body)
        # cuisines
        result.merge!({:cuisines => cuisines["cuisines"]})
        result
    end
end
