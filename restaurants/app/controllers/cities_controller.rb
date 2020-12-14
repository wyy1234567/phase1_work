class CitiesController < ApplicationController

    def search
        api_key = params[:api_key]
        city_name = params[:city_name]
        search_result = City.fetch_info(api_key, city_name)
        render json: search_result.to_json
    end
end
