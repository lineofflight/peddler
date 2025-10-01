# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipment_invoicing_v0/error"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The response schema for the submitInvoice operation.
      SubmitInvoiceResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
