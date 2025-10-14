# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A fee event related to Amazon Imaging services.
      ImagingServicesFeeEvent = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item for which the imaging service
        # was requested.
        attribute?(:asin, String, from: "ASIN")

        # @return [Array<FeeComponent>] A list of fees associated with the event.
        attribute?(:fee_list, [FeeComponent], from: "FeeList")

        # @return [String] The identifier for the imaging services request.
        attribute?(:imaging_request_billing_item_id, String, from: "ImagingRequestBillingItemID")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")
      end
    end
  end
end
