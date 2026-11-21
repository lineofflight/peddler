# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      Amount = Structure.new do
        # The unit of measure for the amount. Possible values: EACHES.
        attribute(:unit, String, null: false)

        # The amount of a product in the associated unit of measurement.
        attribute(:value, String, null: false)
      end
    end
  end
end
