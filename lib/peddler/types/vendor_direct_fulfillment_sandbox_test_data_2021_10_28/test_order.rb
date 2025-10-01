# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # Error response returned when the request is unsuccessful.
      TestOrder = Structure.new do
        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:order_id, String, from: "orderId")
      end
    end
  end
end
