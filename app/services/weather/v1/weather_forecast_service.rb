# frozen_string_literal: true

module Weather
  module V1
    # WeatherForecastService
    class WeatherForecastService
      def initialize(params:)
        @params = params
      end

      def call
        url = URI("#{ENV['WEATHER_API_BASE_URL']}?key="\
                 "#{ENV['WEATHER_API_KEY']}&q=#{@params[:pin_code]}&days=0")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = https.request(request)
        JSON.parse(response.body)
      end
    end
  end
end
