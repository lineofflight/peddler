# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      Amount = Structure.new do
        # @return [String] The unit of measure for the amount. Possible values: EACHES.
        attribute(:unit, String, null: false)

        # @return [String] The amount of a product in the associated unit of measurement.
        attribute(:value, String, null: false)
      end
    end
  end
end
