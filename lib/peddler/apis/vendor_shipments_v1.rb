# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Shipments
    #
    # The Selling Partner API for Retail Procurement Shipments provides programmatic access to retail shipping data for
    # vendors.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-shipments-api-model/vendorShipments.json
    module VendorShipmentsV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_shipments_v1.get_shipment_details" => -> { GetShipmentDetailsResponse },
        "vendor_shipments_v1.get_shipment_labels" => -> { GetShipmentLabels },
        "vendor_shipments_v1.submit_shipment_confirmations" => -> { SubmitShipmentConfirmationsResponse },
        "vendor_shipments_v1.submit_shipments" => -> { SubmitShipmentConfirmationsResponse },
      })
    end
  end
end
