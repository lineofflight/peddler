# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Object contains customised data requested by a shipper to be printed on a shipping label.
      RequestedLabelCustomization = Structure.new do
        # @return [Array<LabelAttribute>]
        attribute(:request_attributes, Array, from: "requestAttributes")
      end
    end
  end
end
