# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      ShippingTime = Structure.new do
        # @return [String] Indicates whether the item is available for shipping now, or on a known or unknown date in
        # the future.
        attribute?(:availability_type, String, from: "availabilityType")

        # @return [String] The date when the item will be available for shipping. Only displayed for items that are not
        # currently available for shipping.
        attribute?(:available_date, String, from: "availableDate")

        # @return [Integer] The maximum time, in hours, that the item will likely be shipped after the order has been
        # placed.
        attribute?(:maximum_hours, Integer, from: "maximumHours")

        # @return [Integer] The minimum time, in hours, that the item will likely be shipped after the order has been
        # placed.
        attribute?(:minimum_hours, Integer, from: "minimumHours")
      end
    end
  end
end
