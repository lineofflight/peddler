# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
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
