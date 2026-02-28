# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentReturns20240911
      # Invoice-related information for the return created for Amazon SmartConnect.
      InvoiceInformation = Structure.new do
        # @return [String] The unique ID of the invoice that corresponds to the return.
        attribute(:id, String, null: false)
      end
    end
  end
end
