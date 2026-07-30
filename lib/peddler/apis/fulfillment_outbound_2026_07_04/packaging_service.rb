# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Specify packaging requirements.
      PackagingService = Structure.new do
        # @return [String] Whether to require an overbox for the shipment. Possible values: `REQUIRED`, `NOT_REQUIRED`.
        attribute?(:overbox, String)

        # @return [String] The packaging option to use for fulfillment. Possible values: `UNBRANDED`, `ANY`.
        attribute?(:packaging_option, String, from: "packagingOption")

        # @return [OrderPackingSlip] Packing slip settings. Applying any settings requires that the order has a printed
        #   slip.
        attribute?(:packing_slip, OrderPackingSlip, from: "packingSlip")
      end
    end
  end
end
