# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_invoices_v1/invoice"

module Peddler
  module Types
    module VendorInvoicesV1
      # The request schema for the submitInvoices operation.
      SubmitInvoicesRequest = Structure.new do
        # @return [Array<Invoice>] An array of Invoice objects representing the invoices or credit notes to be
        # submitted.
        attribute?(:invoices, [Invoice])
      end
    end
  end
end
