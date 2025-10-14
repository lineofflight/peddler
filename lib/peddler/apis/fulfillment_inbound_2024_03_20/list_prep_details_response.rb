# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The response to the `listPrepDetails` operation.
      ListPrepDetailsResponse = Structure.new do
        # @return [Array<MskuPrepDetail>] A list of MSKUs and related prep details.
        attribute(:msku_prep_details, [MskuPrepDetail], from: "mskuPrepDetails")
      end
    end
  end
end
