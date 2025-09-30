# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/compliance_detail"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listItemComplianceDetails` response.
      ListItemComplianceDetailsResponse = Structure.new do
        # @return [Array<ComplianceDetail>] List of compliance details.
        attribute?(:compliance_details, [ComplianceDetail], from: "complianceDetails")
      end
    end
  end
end
