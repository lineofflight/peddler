# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The request for the `listReturnReasonCodes` operation.
      ListReturnReasonCodesResult = Structure.new do
        # @return [Array<ReasonCodeDetails>]
        attribute?(:reason_code_details, [ReasonCodeDetails], from: "reasonCodeDetails")
      end
    end
  end
end
