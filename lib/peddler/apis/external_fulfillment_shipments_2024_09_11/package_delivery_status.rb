# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The delivery status of the package.
      PackageDeliveryStatus = Structure.new do
        # @return [String] The reason for the sub-status.
        attribute?(:reason, String)

        # @return [String] The status of the package.
        attribute?(:status, String)

        # @return [String] The sub-status of the package.
        attribute?(:sub_status, String, from: "subStatus")
      end
    end
  end
end
