# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module DeliveryByAmazon20220701
      # Individual invoice status entry.
      InvoiceStatus = Structure.new do
        # The unique invoice identifier (NF-e access key for Brazilian invoices).
        attribute(:id, String, null: false)

        # The current status of this invoice. Known values: `Processing`, `Accepted`, `Rejected`, `NotFound`.
        attribute(:status, String, null: false)
      end
    end
  end
end
