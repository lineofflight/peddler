# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # A way to configure this packing option. Some box content information sources might not be allowed. Non-standard
      # minimum and maximum box weights might be enforced.
      PackingConfiguration = Structure.new do
        # The box content information sources that are allowed. Known values: `BOX_CONTENT_PROVIDED`, `MANUAL_PROCESS`,
        # `BARCODE_2D`.
        attribute?(:box_packing_methods, Array, from: "boxPackingMethods")

        attribute?(:box_requirements, BoxRequirements, from: "boxRequirements")

        # A list of supported shipping requirements for this packing configuration.
        attribute?(:shipping_requirements, [ShippingRequirements], from: "shippingRequirements")
      end
    end
  end
end
