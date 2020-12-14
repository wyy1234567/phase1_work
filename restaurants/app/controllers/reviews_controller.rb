class ReviewsController < ApplicationController

    # get "/reviews/:cuisine_id/:city_id/:api_key", to: "reviews#find_reviews"
    def find_reviews
        cuisine_id = params[:cuisine_id]
        city_id = params[:city_id]
        api_key = params[:api_key]
        reviews = Review.search_reviews(cuisine_id, city_id, api_key)
        render json: reviews.to_json
    end
end
