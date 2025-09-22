# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/window"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Specifies the date that the seller expects their shipment will be shipped.
      Dates = Structure.new do
        # @return [Window]
        attribute(:ready_to_ship_window, Window, from: "readyToShipWindow")
      end
    end
  end
end
