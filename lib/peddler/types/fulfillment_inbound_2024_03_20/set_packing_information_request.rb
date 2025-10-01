# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/package_grouping_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `setPackingInformation` request.
      SetPackingInformationRequest = Structure.new do
        # @return [Array<PackageGroupingInput>] List of packing information for the inbound plan.
        attribute(:package_groupings, [PackageGroupingInput], from: "packageGroupings")
      end
    end
  end
end
