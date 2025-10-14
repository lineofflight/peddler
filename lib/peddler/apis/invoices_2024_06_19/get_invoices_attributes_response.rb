# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      GetInvoicesAttributesResponse = Structure.new do
        # @return [InvoicesAttributes]
        attribute?(:invoices_attributes, InvoicesAttributes, from: "invoicesAttributes")
      end
    end
  end
end
