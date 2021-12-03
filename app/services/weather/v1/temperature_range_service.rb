# frozen_string_literal: true

module Weather
  module V1
    # TemperatureRangeService
    class TemperatureRangeService
      ADMIN_ROLE = 'admin'

      def initialize(max_temp:)
        @max_temp = max_temp
      end

      def call
        if hot?
          'Hot'
        elsif warm?
          'Warm'
        elsif cold?
          'Cold'
        end
      end

      def temperature
        admin_user = User.where(role: ADMIN_ROLE).first
        return false if admin_user.blank?

        admin_user.temperature
      end

      def hot?
        @max_temp.between?(temperature['hot_to'].to_f,
                           temperature['hot_from'].to_f)
      end

      def warm?
        @max_temp.between?(temperature['warm_to'].to_f,
                           temperature['warm_from'].to_f)
      end

      def cold?
        @max_temp.between?(temperature['cold_to'].to_f,
                           temperature['cold_from'].to_f)
      end
    end
  end
end
