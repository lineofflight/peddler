# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The request schema for the purchaseLabels operation.
      PurchaseLabelsRequest = Structure.new do
        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, from: "labelSpecification")

        # @return [String]
        attribute(:rate_id, String, from: "rateId")
      end
    end
  end
end
