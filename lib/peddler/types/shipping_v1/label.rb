# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/label_specification"

module Peddler
  module Types
    module ShippingV1
      # The label details of the container.
      Label = Structure.new do
        # @return [LabelSpecification]
        attribute?(:label_specification, LabelSpecification, from: "labelSpecification")

        # @return [String]
        attribute?(:label_stream, String, from: "labelStream")
      end
    end
  end
end
