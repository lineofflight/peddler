# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The request schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelRequest = Structure.new do
        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, null: false, from: "labelSpecification")
      end
    end
  end
end
