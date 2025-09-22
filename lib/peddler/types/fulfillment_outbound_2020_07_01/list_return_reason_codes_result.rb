# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/reason_code_details"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The request for the `listReturnReasonCodes` operation.
      ListReturnReasonCodesResult = Structure.new do
        # @return [Array<ReasonCodeDetails>]
        attribute(:reason_code_details, [ReasonCodeDetails], from: "reasonCodeDetails")
      end
    end
  end
end
