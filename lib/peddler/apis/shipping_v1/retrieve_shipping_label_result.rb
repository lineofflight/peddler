# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelResult = Structure.new do
        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, null: false, from: "labelSpecification")

        # @return [String]
        attribute(:label_stream, String, null: false, from: "labelStream")
      end
    end
  end
end
