# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/error"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] An array of individual error objects containing error details.
        attribute(:errors, [Error])
      end
    end
  end
end
