# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # An object which contains the delivery condition and the quantity of upcoming deliveries associated with that
      # condition for an offer.
      DeliveriesCondition = Structure.new do
        # @return [String] The condition type of upcoming deliveries for the offer.
        attribute?(:condition, String)

        # @return [Integer] The number of upcoming deliveries in the next 30 days associated with this delivery
        #   condition.
        attribute?(:next30_days_deliveries, Integer, from: "next30DaysDeliveries")
      end
    end
  end
end
