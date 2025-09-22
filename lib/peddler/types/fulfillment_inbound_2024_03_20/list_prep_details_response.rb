# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/msku_prep_detail"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The response to the `listPrepDetails` operation.
      ListPrepDetailsResponse = Structure.new do
        # @return [Array<MskuPrepDetail>] A list of MSKUs and related prep details.
        attribute(:msku_prep_details, [MskuPrepDetail], from: "mskuPrepDetails")
      end
    end
  end
end
