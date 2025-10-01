# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_fees_v0/fees_estimate_error"
require "peddler/types/product_fees_v0/fees_estimate"
require "peddler/types/product_fees_v0/fees_estimate_identifier"

module Peddler
  module Types
    module ProductFeesV0
      # An item identifier and the estimated fees for the item.
      FeesEstimateResult = Structure.new do
        # @return [FeesEstimateError] An error object with a type, code, and message.
        attribute?(:error, FeesEstimateError, from: "Error")

        # @return [FeesEstimate] The total estimated fees for an item and a list of details.
        attribute?(:fees_estimate, FeesEstimate, from: "FeesEstimate")

        # @return [FeesEstimateIdentifier] Information used to identify a fees estimate request.
        attribute?(:fees_estimate_identifier, FeesEstimateIdentifier, from: "FeesEstimateIdentifier")

        # @return [String] The status of the fee request. Possible values: Success, ClientError, ServiceError.
        attribute?(:status, String, from: "Status")
      end
    end
  end
end
