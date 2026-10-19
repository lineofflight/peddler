# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The delivery status of the package.
      PackageDeliveryStatus = Structure.new do
        # The reason for the sub-status.
        attribute?(:reason, String)

        # The status of the package. Known values: `CREATED`, `PICKUP_SLOT_RETRIEVED`, `INVOICE_GENERATED`,
        # `SHIPLABEL_GENERATED`, `SHIPPED`, `DELIVERED`.
        attribute?(:status, String)

        # The sub-status of the package. Known values: `OUT_FOR_DELIVERY`, `DELIVERED`, `NOT_DELIVERED`,
        # `UNDELIVERABLE`.
        attribute?(:sub_status, String, from: "subStatus")
      end
    end
  end
end
