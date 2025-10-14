# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `setPrepDetails` request.
      SetPrepDetailsRequest = Structure.new do
        # @return [String] The marketplace ID. For a list of possible values, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<MskuPrepDetailInput>] A list of MSKUs and related prep details.
        attribute(:msku_prep_details, [MskuPrepDetailInput], from: "mskuPrepDetails")
      end
    end
  end
end
