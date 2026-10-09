# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Delivery Shipment Invoicing
    #
    # The Selling Partner API for Delivery Shipment Invoicing helps you programmatically retrieve shipment invoice
    # information in the Brazil Amazon store for a selling partner’s orders.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/delivery-by-amazon/deliveryShipmentInvoiceV2022-07-01.json
    module DeliveryByAmazon20220701
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "delivery_by_amazon_2022_07_01.get_invoice_status" => -> { GetInvoiceStatusResponse },
        "delivery_by_amazon_2022_07_01.submit_invoice" => -> { SubmitInvoiceResponse },
      })
    end
  end
end
