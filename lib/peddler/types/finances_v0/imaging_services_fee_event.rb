# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/fee_component"

module Peddler
  module Types
    module FinancesV0
      # A fee event related to Amazon Imaging services.
      ImagingServicesFeeEvent = Structure.new do
        # @return [String] The identifier for the imaging services request.
        attribute(:imaging_request_billing_item_id, String, from: "ImagingRequestBillingItemID")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item for which the imaging service
        # was requested.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [Array<FeeComponent>] A list of fees associated with the event.
        attribute(:fee_list, [FeeComponent], from: "FeeList")
      end
    end
  end
end
