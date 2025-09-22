# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The time range in which an item will likely be shipped once an order has been placed.
      DetailedShippingTimeType = Structure.new do
        # @return [Integer] The minimum time, in hours, that the item will likely be shipped after the order has been
        # placed.
        attribute(:minimum_hours, Integer, from: "minimumHours")

        # @return [Integer] The maximum time, in hours, that the item will likely be shipped after the order has been
        # placed.
        attribute(:maximum_hours, Integer, from: "maximumHours")

        # @return [String] The date when the item will be available for shipping. Only displayed for items that are not
        # currently available for shipping.
        attribute(:available_date, String, from: "availableDate")

        # @return [String] Indicates whether the item is available for shipping now, or on a known or an unknown date in
        # the future. If known, the availableDate property indicates the date that the item will be available for
        # shipping. Possible values: NOW, FUTURE_WITHOUT_DATE, FUTURE_WITH_DATE.
        attribute(:availability_type, String, from: "availabilityType")
      end
    end
  end
end
