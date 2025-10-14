# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listItemComplianceDetails` response.
      ListItemComplianceDetailsResponse = Structure.new do
        # @return [Array<ComplianceDetail>] List of compliance details.
        attribute?(:compliance_details, [ComplianceDetail], from: "complianceDetails")
      end
    end
  end
end
