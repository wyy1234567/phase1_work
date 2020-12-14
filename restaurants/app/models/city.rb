class City < ApplicationRecord
    
    # search_result = City.fetch_info(api_key, city_name) in controller
    def self.fetch_info(api_key, city_name)
        #return a hash, has city infomation and cuisines in that city
        result = {}
        city_url = URI.parse("https://developers.zomato.com/api/v2.1/cities?q=#{city_name}&count=1")
        city_request = Net::HTTP::Get.new(city_url)
        city_request["Accept"] = "application/json"
        city_request["user-key"] = api_key
        city_req_options = {
            use_ssl: city_url.scheme == "https",
        }
        city_response = Net::HTTP.start(city_url.hostname, city_url.port, city_req_options) do |http|
            http.request(city_request)
        end
        city_info = JSON.parse(city_response.body)

        if city_info["location_suggestions"].size == 0 
            return "City not exist, try another one"
        end
        city_id = city_info["location_suggestions"][0]["id"]
        result = {:city_info => city_info["location_suggestions"][0]}
        
        cuisine_list = City.city_cuisines(city_id, api_key)
        result.merge!({:cuisines => cuisine_list})
        result
    end


    def self.city_cuisines(city_id, api_key)

        cuisine_url = URI.parse("https://developers.zomato.com/api/v2.1/cuisines?city_id=#{city_id}")
        cuisine_request = Net::HTTP::Get.new(cuisine_url)
        cuisine_request["Accept"] = "application/json"
        cuisine_request["user-key"] = api_key
        cuisine_req_options = {
            use_ssl: cuisine_url.scheme == "https",
        }
        cuisine_response = Net::HTTP.start(cuisine_url.hostname, cuisine_url.port, cuisine_req_options) do |http|
            http.request(cuisine_request)
        end
        cuisines = JSON.parse(cuisine_response.body)
        
        cuisine_list = []
        cuisines["cuisines"].each do |hash|
            cuisine_list << hash["cuisine"]
        end

        cuisine_list
    end

end
