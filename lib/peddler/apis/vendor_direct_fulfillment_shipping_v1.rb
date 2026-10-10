# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Shipping
    #
    # The Selling Partner API for Direct Fulfillment Shipping provides programmatic access to a direct fulfillment
    # vendor's shipping data.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-shipping-api-model/vendorDirectFulfillmentShippingV1.json
    module VendorDirectFulfillmentShippingV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_direct_fulfillment_shipping_v1.get_customer_invoice" => -> { GetCustomerInvoiceResponse },
        "vendor_direct_fulfillment_shipping_v1.get_customer_invoices" => -> { GetCustomerInvoicesResponse },
        "vendor_direct_fulfillment_shipping_v1.get_packing_slip" => -> { GetPackingSlipResponse },
        "vendor_direct_fulfillment_shipping_v1.get_packing_slips" => -> { GetPackingSlipListResponse },
        "vendor_direct_fulfillment_shipping_v1.get_shipping_label" => -> { GetShippingLabelResponse },
        "vendor_direct_fulfillment_shipping_v1.get_shipping_labels" => -> { GetShippingLabelListResponse },
        "vendor_direct_fulfillment_shipping_v1.submit_shipment_confirmations" => -> { SubmitShipmentConfirmationsResponse },
        "vendor_direct_fulfillment_shipping_v1.submit_shipment_status_updates" => -> { SubmitShipmentStatusUpdatesResponse },
        "vendor_direct_fulfillment_shipping_v1.submit_shipping_label_request" => -> { SubmitShippingLabelsResponse },
      })
    end
  end
end
