require 'rest-client'

class Review < ApplicationRecord

    # reviews = Review.search_reviews(cuisine_id, city_id, api_key)
    def self.search_reviews(cuisine_id, city_id, api_key)
        result = []
        search_url = URI.parse("https://developers.zomato.com/api/v2.1/search?entity_id=#{city_id}&entity_type=city&count=3&cuisines=#{cuisine_id}")
        request = Net::HTTP::Get.new(search_url)
        request["Accept"] = "application/json"
        request["user-key"] = api_key
        req_options = {
            use_ssl: search_url.scheme == "https",
        }
        response = Net::HTTP.start(search_url.hostname, search_url.port, req_options) do |http|
            http.request(request)
        end
        restrurants = JSON.parse(response.body)["restaurants"]

        restrurants.each do |res|
            res_and_reviews = {}
            res_id = res["restaurant"]["R"]["res_id"]
            res_and_reviews = {:restaurant_info => res["restaurant"]}
            reviews = Review.fetch_reviews(res_id, api_key)
            res_and_reviews.merge!({:reviews => reviews})
            result << res_and_reviews

        end
        result
    end

    def self.fetch_reviews(restrurant_id, api_key)
        reviews_url = "https://developers.zomato.com/api/v2.1/reviews?res_id=#{restrurant_id}"
        header = {"Accept" => "application/json", "user-key" => api_key}
        resp = RestClient.get(reviews_url, header)
        result = JSON.parse(resp.body)
        reviews = result["user_reviews"]
    end

end
