# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/package_tracking_details"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getPackageTrackingDetails` operation.
      GetPackageTrackingDetailsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getPackageTrackingDetails`
        # operation.
        attribute?(:errors, [Error])

        # @return [PackageTrackingDetails] The payload for the `getPackageTrackingDetails` operation.
        attribute?(:payload, PackageTrackingDetails)
      end
    end
  end
end
