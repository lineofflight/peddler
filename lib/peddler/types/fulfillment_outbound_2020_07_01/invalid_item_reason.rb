# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The reason that the item is invalid for return.
      InvalidItemReason = Structure.new do
        # @return [String]
        attribute(:invalid_item_reason_code, String, from: "invalidItemReasonCode")

        # @return [String] A human readable description of the invalid item reason code.
        attribute(:description, String)
      end
    end
  end
end
