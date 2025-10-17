# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The response schema for the `getPackageTrackingDetails` operation.
      GetPackageTrackingDetailsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getPackageTrackingDetails`
        #   operation.
        attribute?(:errors, [Error])

        # @return [PackageTrackingDetails] The payload for the `getPackageTrackingDetails` operation.
        attribute?(:payload, PackageTrackingDetails)
      end
    end
  end
end
