# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # An object which contains the projected subscriber demand for the offer over different time horizons.
      ForecastDeliveries = Structure.new do
        # @return [Integer] The projected number of subscriber deliveries in the next 15 days.
        attribute?(:next15_days_deliveries, Integer, from: "next15DaysDeliveries")

        # @return [Integer] The projected number of subscriber deliveries in the next 30 days.
        attribute?(:next30_days_deliveries, Integer, from: "next30DaysDeliveries")

        # @return [Integer] The projected number of subscriber deliveries in the next 60 days.
        attribute?(:next60_days_deliveries, Integer, from: "next60DaysDeliveries")

        # @return [Integer] The projected number of subscriber deliveries in the next 90 days.
        attribute?(:next90_days_deliveries, Integer, from: "next90DaysDeliveries")
      end
    end
  end
end
