# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Amazon External Fulfillment Shipments Processing
    #
    # You can use the External Fulfillment Shipments API to retrieve, manage, and track shipments processed through
    # Amazon's external fulfillment network. Use this API to get shipment details, monitor status changes, and access
    # fulfillment requirements.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentShipments_2024-09-11.json
    module ExternalFulfillmentShipments20240911
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "external_fulfillment_shipments_2024_09_11.create_sandbox_shipment" => -> { CreateSandboxShipmentResponse },
        "external_fulfillment_shipments_2024_09_11.generate_invoice" => -> { InvoiceResponse },
        "external_fulfillment_shipments_2024_09_11.generate_ship_labels" => -> { ShipLabelsResponse },
        "external_fulfillment_shipments_2024_09_11.get_shipment" => -> { Shipment },
        "external_fulfillment_shipments_2024_09_11.get_shipments" => -> { ShipmentsResponse },
        "external_fulfillment_shipments_2024_09_11.retrieve_invoice" => -> { InvoiceResponse },
        "external_fulfillment_shipments_2024_09_11.retrieve_shipping_options" => -> { ShippingOptionsResponse },
      })
    end
  end
end
