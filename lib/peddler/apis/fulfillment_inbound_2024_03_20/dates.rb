# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Specifies the date that the seller expects their shipment will be shipped.
      Dates = Structure.new do
        # @return [Window]
        attribute?(:ready_to_ship_window, Window, from: "readyToShipWindow")
      end
    end
  end
end
