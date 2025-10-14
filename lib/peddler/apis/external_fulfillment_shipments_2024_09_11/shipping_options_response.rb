# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The response to the `retrieveShippingOptions` operation. The response contains shipping options on a per-package
      # basis from which the seller has to select one shipping option while they retrieve the shipping label. If the
      # particular marketplace channel does not support scheduled shipping options, then this response will be empty.
      ShippingOptionsResponse = Structure.new do
        # @return [ShippingOptions] The recommended shipping options that a marketplace channel provides to the seller.
        attribute?(:recommended_shipping_option, ShippingOptions, from: "recommendedShippingOption")

        # @return [Array<ShippingOptions>] A list of shipping options.
        attribute?(:shipping_options, [ShippingOptions], from: "shippingOptions")
      end
    end
  end
end
