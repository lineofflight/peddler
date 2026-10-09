# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Shipping
    #
    # Use the Selling Partner API for Direct Fulfillment Shipping to access a direct fulfillment vendor's shipping data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-shipping-api-model/vendorDirectFulfillmentShipping_2021-12-28.json
    module VendorDirectFulfillmentShipping20211228
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_direct_fulfillment_shipping_2021_12_28.create_container_label" => -> { CreateContainerLabelResponse },
        "vendor_direct_fulfillment_shipping_2021_12_28.create_shipping_labels" => -> { ShippingLabel },
        "vendor_direct_fulfillment_shipping_2021_12_28.get_customer_invoice" => -> { CustomerInvoice },
        "vendor_direct_fulfillment_shipping_2021_12_28.get_customer_invoices" => -> { CustomerInvoiceList },
        "vendor_direct_fulfillment_shipping_2021_12_28.get_packing_slip" => -> { PackingSlip },
        "vendor_direct_fulfillment_shipping_2021_12_28.get_packing_slips" => -> { PackingSlipList },
        "vendor_direct_fulfillment_shipping_2021_12_28.get_shipping_label" => -> { ShippingLabel },
        "vendor_direct_fulfillment_shipping_2021_12_28.get_shipping_labels" => -> { ShippingLabelList },
        "vendor_direct_fulfillment_shipping_2021_12_28.submit_shipment_confirmations" => -> { TransactionReference },
        "vendor_direct_fulfillment_shipping_2021_12_28.submit_shipment_status_updates" => -> { TransactionReference },
        "vendor_direct_fulfillment_shipping_2021_12_28.submit_shipping_label_request" => -> { TransactionReference },
      })
    end
  end
end
