class Review < ApplicationRecord

    # reviews = Review.search_reviews(cuisine_id, city_id, api_key)
    # https://developers.zomato.com/api/v2.1/search?entity_id=280&entity_type=city&count=5&cuisines=1
    def self.search_reviews(cuisine_id, city_id, api_key)
        search_url = URI.parse("https://developers.zomato.com/api/v2.1/search?entity_id=#{city_id}&entity_type=city&count=5&cuisines=#{cuisine_id}")
        request = Net::HTTP::Get.new(search_url)
        request["Accept"] = "application/json"
        request["user-key"] = api_key
        req_options = {
            use_ssl: search_url.scheme == "https",
        }
        response = Net::HTTP.start(search_url.hostname, search_url.port, req_options) do |http|
            http.request(request)
        end

        result = JSON.parse(response.body)
    end
end
