# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      ShippingTime = Structure.new do
        attribute(:availability_type, String, null: false, from: "AvailabilityType")

        attribute(:available_date, String, null: false, from: "AvailableDate")

        attribute(:maximum_hours, Integer, null: false, from: "MaximumHours")

        attribute(:minimum_hours, Integer, null: false, from: "MinimumHours")
      end
    end
  end
end
