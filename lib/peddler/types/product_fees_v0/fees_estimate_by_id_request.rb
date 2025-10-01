# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_fees_v0/fees_estimate_request"

module Peddler
  module Types
    module ProductFeesV0
      # A product, marketplace, and proposed price used to request estimated fees.
      FeesEstimateByIdRequest = Structure.new do
        # @return [String]
        attribute(:id_type, String, from: "IdType")

        # @return [String] The item identifier.
        attribute(:id_value, String, from: "IdValue")

        # @return [FeesEstimateRequest]
        attribute?(:fees_estimate_request, FeesEstimateRequest, from: "FeesEstimateRequest")
      end
    end
  end
end
