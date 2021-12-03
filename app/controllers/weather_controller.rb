# frozen_string_literal: true

# WeatherController
class WeatherController < ApplicationController
  before_action :verify_pincode!

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
    return true unless weather_forecast.dig('error',
                                            'message')
                                       .eql?('No matching location found.')

    render json: {}, status: :bad_request
  end

  def max_temp
    weather_forecast.dig('forecast', 'forecastday')
                    .try(:first).dig('day',
                                     'maxtemp_c')
                    .to_f
  end

  def country_uk?
    weather_forecast.dig('location', 'country').eql?('UK')
  end

  def temperature_range
    ::Weather::V1::TemperatureRangeService.new(max_temp: max_temp)
                                          .call
  end

  def weather_forecast
    @weather_forecast ||= ::Weather::V1::WeatherForecastService
                          .new(params: params)
                          .call
  end
end
