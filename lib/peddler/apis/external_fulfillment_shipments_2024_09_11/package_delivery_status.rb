# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The delivery status of the package.
      PackageDeliveryStatus = Structure.new do
        # @return [String] The reason for the sub-status. Refer
        #   [table](https://developer-docs.amazon/sp-api/docs/process-shipment#step-6-update-the-package-status) for
        #   possible values.
        attribute?(:reason, String)

        # @return [String] The status of the package. Known values: `SHIPPED`, `DELIVERED`.
        attribute?(:status, String)

        # @return [String] The sub-status of the package. Known values: `OUT_FOR_DELIVERY`, `DELIVERED`,
        #   `NOT_DELIVERED`, `UNDELIVERABLE`.
        attribute?(:sub_status, String, from: "subStatus")
      end
    end
  end
end
