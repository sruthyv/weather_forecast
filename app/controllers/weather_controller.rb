# frozen_string_literal: true

# WeatherController
class WeatherController < ApplicationController
  before_action :verify_pincode!

  ADMIN_ROLE = 'admin'
  def forecast
    if country_uk?
      data = { max_temp: max_temp,
               temperature_range: temperature_range }
      render json: data, status: :ok
    else
      render json: { max_temp: 0 }, status: :not_found
    end
  end

  private

  def verify_pincode!
    return true unless weather_api_response.dig('error',
                                                'message')
                                           .eql?('No matching location found.')

    render json: {}, status: :bad_request
  end

  def max_temp
    weather_api_response.dig('forecast', 'forecastday')
                        .try(:first).dig('day',
                                         'maxtemp_c')
                        .to_f
  end

  def country_uk?
    weather_api_response.dig('location', 'country').eql?('UK')
  end

  def weather_api_response
    @weather_api_response ||= begin
      url = URI("#{ENV['WEATHER_API_BASE_URL']}?key=#{ENV['WEATHER_API_KEY']}"\
                "&q=#{params[:pin_code]}&days=0")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = https.request(request)
      JSON.parse(response.body)
    end
  end

  def temperature
    admin_user = User.where(role: ADMIN_ROLE).first
    return false if admin_user.blank?

    admin_user.temperature
  end

  def temperature_range
    if hot?
      'Hot'
    elsif warm?
      'Warm'
    elsif cold?
      'Cold'
    end
  end

  def hot?
    max_temp.between?(temperature['hot_to'].to_f, temperature['hot_from'].to_f)
  end

  def warm?
    max_temp.between?(temperature['warm_to'].to_f,
                      temperature['warm_from'].to_f)
  end

  def cold?
    max_temp.between?(temperature['cold_to'].to_f,
                      temperature['cold_from'].to_f)
  end
end
