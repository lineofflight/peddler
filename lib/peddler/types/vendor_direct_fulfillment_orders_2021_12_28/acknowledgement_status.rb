# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Status of acknowledgement.
      AcknowledgementStatus = Structure.new do
        # @return [String] Acknowledgement code is a unique two digit value which indicates the status of the
        # acknowledgement. For a list of acknowledgement codes that Amazon supports, see the Vendor Direct Fulfillment
        # APIs Use Case Guide.
        attribute?(:code, String)

        # @return [String] Reason for the acknowledgement code.
        attribute?(:description, String)
      end
    end
  end
end
