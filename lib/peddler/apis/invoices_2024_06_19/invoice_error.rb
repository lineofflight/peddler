# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # An invoice creation error occurrence.
      InvoiceError = Structure.new do
        # @return [String] A text description of the error.
        attribute?(:description, String)

        # @return [String] The code of the error.
        attribute?(:error_code, String, from: "errorCode")
      end
    end
  end
end
