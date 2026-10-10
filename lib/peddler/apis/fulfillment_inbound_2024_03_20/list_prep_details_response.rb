# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The response to the `listPrepDetails` operation.
      ListPrepDetailsResponse = Structure.new do
        # A list of MSKUs and related prep details.
        attribute(:msku_prep_details, [MskuPrepDetail], null: false, from: "mskuPrepDetails")
      end
    end
  end
end
