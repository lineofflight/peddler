# frozen_string_literal: true

require "peddler/types/shipping_v1/label_specification"

module Peddler
  module Types
    module ShippingV1
      # The request schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelRequest = Structure.new do
        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, from: "labelSpecification")
      end
    end
  end
end
