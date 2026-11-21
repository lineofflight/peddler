# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductFeesV0
      # A product, marketplace, and proposed price used to request estimated fees.
      FeesEstimateByIdRequest = Structure.new do
        # Known values: `ASIN`, `SellerSKU`.
        attribute(:id_type, String, null: false, from: "IdType")

        # The item identifier.
        attribute(:id_value, String, null: false, from: "IdValue")

        attribute?(:fees_estimate_request, FeesEstimateRequest, from: "FeesEstimateRequest")
      end
    end
  end
end
