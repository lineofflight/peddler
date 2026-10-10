# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Shipment Invoicing
    #
    # The Selling Partner API for Shipment Invoicing helps you programmatically retrieve shipment invoice information in
    # the Brazil marketplace for a selling partner’s Fulfillment by Amazon (FBA) orders.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/shipment-invoicing-api-model/shipmentInvoicingV0.json
    module ShipmentInvoicingV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "shipment_invoicing_v0.get_invoice_status" => -> { GetInvoiceStatusResponse },
        "shipment_invoicing_v0.get_shipment_details" => -> { GetShipmentDetailsResponse },
        "shipment_invoicing_v0.submit_invoice" => -> { SubmitInvoiceResponse },
      })
    end
  end
end
