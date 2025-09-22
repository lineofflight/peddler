# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/label_specification"

module Peddler
  module Types
    module ShippingV1
      # The request schema for the purchaseLabels operation.
      PurchaseLabelsRequest = Structure.new do
        # @return [String]
        attribute(:rate_id, String, from: "rateId")

        # @return [LabelSpecification]
        attribute(:label_specification, LabelSpecification, from: "labelSpecification")
      end
    end
  end
end
