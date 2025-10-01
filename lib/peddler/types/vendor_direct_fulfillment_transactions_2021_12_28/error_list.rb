# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_transactions_2021_12_28/error"

module Peddler
  module Types
    module VendorDirectFulfillmentTransactions20211228
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] An array of individual error objects containing error details.
        attribute(:errors, [Error])
      end
    end
  end
end
