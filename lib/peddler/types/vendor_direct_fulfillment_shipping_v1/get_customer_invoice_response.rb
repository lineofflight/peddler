# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/customer_invoice"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the getCustomerInvoice operation.
      GetCustomerInvoiceResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [CustomerInvoice] The payload for the getCustomerInvoice operation.
        attribute?(:payload, CustomerInvoice)
      end
    end
  end
end
