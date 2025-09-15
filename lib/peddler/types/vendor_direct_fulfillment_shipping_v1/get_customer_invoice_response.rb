# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/customer_invoice"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getCustomerInvoice operation.
      GetCustomerInvoiceResponse = Structure.new do
        # @return [CustomerInvoice] The payload for the getCustomerInvoice operation.
        attribute(:payload, CustomerInvoice)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
