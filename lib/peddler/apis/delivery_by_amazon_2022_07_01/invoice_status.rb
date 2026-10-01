# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DeliveryByAmazon20220701
      # Individual invoice status entry.
      InvoiceStatus = Structure.new do
        # @return [String] The unique invoice identifier (NF-e access key for Brazilian invoices).
        attribute(:id, String, null: false)

        # @return [String] The current status of this invoice.
        attribute(:status, String, null: false)
      end
    end
  end
end
