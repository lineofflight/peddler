# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Invoices20240619
      # An invoice creation error occurred.
      InvoiceError = Structure.new do
        # A description of the error.
        attribute?(:description, String)

        # The code of the error.
        attribute?(:error_code, String, from: "errorCode")
      end
    end
  end
end
