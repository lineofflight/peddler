# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      ShippingTime = Structure.new do
        # @return [String]
        attribute(:availability_type, String, null: false, from: "AvailabilityType")

        # @return [String]
        attribute(:available_date, String, null: false, from: "AvailableDate")

        # @return [Integer]
        attribute(:maximum_hours, Integer, null: false, from: "MaximumHours")

        # @return [Integer]
        attribute(:minimum_hours, Integer, null: false, from: "MinimumHours")
      end
    end
  end
end
