# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # A way to configure this packing option. Some box content information sources might not be allowed. Non-standard
      # minimum and maximum box weights might be enforced.
      PackingConfiguration = Structure.new do
        # @return [Array<BoxContentInformationSource>] The box content information sources that are allowed.
        attribute?(:box_packing_methods, Array, from: "boxPackingMethods")

        # @return [BoxRequirements]
        attribute?(:box_requirements, BoxRequirements, from: "boxRequirements")

        # @return [Array<ShippingRequirements>] A list of supported shipping requirements for this packing
        # configuration.
        attribute?(:shipping_requirements, [ShippingRequirements], from: "shippingRequirements")
      end
    end
  end
end
