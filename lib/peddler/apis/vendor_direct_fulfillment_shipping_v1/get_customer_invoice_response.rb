# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
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
