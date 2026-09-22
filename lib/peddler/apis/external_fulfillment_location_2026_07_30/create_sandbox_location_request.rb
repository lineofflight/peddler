# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentLocation20260730
      # The request object for creating a sandbox location.
      CreateSandboxLocationRequest = Structure.new do
        # @return [String] The name for the sandbox location. Idempotency is ensured on this field.
        attribute(:location_name, String, null: false, from: "locationName")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<String>] The list of merchant identifiers to create the location for. This list will have more
        #   than one entry only in case of MSF (Multi-Seller Fulfillment) location creation. In other cases, only one
        #   merchant should be passed in.
        attribute(:merchant_ids, [String], null: false, from: "merchantIds")

        # @return [Array<String>] The list of channels to enable for the location. Defaults to ["FBA", "MFN"] if not
        #   specified.
        attribute?(:channels, [String])
      end
    end
  end
end
