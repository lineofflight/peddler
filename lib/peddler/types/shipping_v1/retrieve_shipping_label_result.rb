# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/label_specification"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelResult = Structure.new do
        # @return [String]
        attribute(:label_stream, String, from: "labelStream")

        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, from: "labelSpecification")
      end
    end
  end
end
