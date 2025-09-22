# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/invoices_2024_06_19/invoices_attributes"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      GetInvoicesAttributesResponse = Structure.new do
        # @return [InvoicesAttributes]
        attribute(:invoices_attributes, InvoicesAttributes, from: "invoicesAttributes")
      end
    end
  end
end
