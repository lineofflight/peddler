# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The payload schema for the retrieveShippingLabel operation.
      RetrieveShippingLabelResult = Structure.new do
        attribute(:label_specification, LabelSpecification, null: false, from: "labelSpecification")

        attribute(:label_stream, String, null: false, from: "labelStream")
      end
    end
  end
end
