# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Packaging requirements for a fulfillment preview.
      PreviewPackagingService = Structure.new do
        # @return [String] Whether to require an overbox for the shipment. Possible values: `REQUIRED`, `NOT_REQUIRED`.
        attribute?(:overbox, String)

        # @return [String] The packaging option to use for fulfillment. Possible values: `UNBRANDED`, `ANY`.
        attribute?(:packaging_option, String, from: "packagingOption")
      end
    end
  end
end
