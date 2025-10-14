# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Object contains customised data requested by a shipper to be printed on a shipping label.
      RequestedLabelCustomization = Structure.new do
        # @return [Array<LabelAttribute>]
        attribute?(:request_attributes, Array, from: "requestAttributes")
      end
    end
  end
end
