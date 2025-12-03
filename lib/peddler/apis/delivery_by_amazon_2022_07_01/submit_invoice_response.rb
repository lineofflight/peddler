# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DeliveryByAmazon20220701
      # The response schema for the submitInvoice operation.
      SubmitInvoiceResponse = Structure.new do
        # @return [Array<Error>] A list of errors returned by this API.
        attribute?(:errors, [Error])
      end
    end
  end
end
