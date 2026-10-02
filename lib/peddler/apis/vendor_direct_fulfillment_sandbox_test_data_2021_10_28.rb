# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Vendor Direct Fulfillment Sandbox Test Data
    #
    # The Selling Partner API for Vendor Direct Fulfillment Sandbox Test Data provides programmatic access to vendor
    # direct fulfillment sandbox test data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-sandbox-test-data-api-model/vendorDirectFulfillmentSandboxData_2021-10-28.json
    module VendorDirectFulfillmentSandboxTestData20211028
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "vendor_direct_fulfillment_sandbox_test_data_2021_10_28.generate_order_scenarios" => -> { TransactionReference },
        "vendor_direct_fulfillment_sandbox_test_data_2021_10_28.get_order_scenarios" => -> { TransactionStatus },
      }.freeze
    end
  end
end
