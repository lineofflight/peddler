# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Package information to update for a specific package in a fulfillment order.
      UpdatePackageRequest = Structure.new do
        attribute(:status, String, null: false)

        # The estimated delivery date and time of the package, in ISO 8601 date time format.
        attribute?(:delivery_time, String, from: "deliveryTime")

        # Tracking information for the package.
        attribute?(:tracking, Tracking)
      end
    end
  end
end
