# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # Error response returned when the request is unsuccessful.
      Error = Structure.new do
        # An error code that identifies the type of error that occurred.
        attribute(:code, String, null: false)

        # A message that describes the error condition.
        attribute(:message, String, null: false)

        # Additional details that can help the caller understand or fix the issue.
        attribute?(:details, String)

        # Identifier of the item that this error is associated with. Present only if the error is an item-level error.
        attribute?(:item_identifier, ItemIdentifier, from: "itemIdentifier")
      end
    end
  end
end
