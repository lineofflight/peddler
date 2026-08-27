# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # An item-level validation issue.
      ItemIssue = Structure.new do
        # @return [String] Issue code identifier.
        attribute(:code, String, null: false)

        # @return [ItemIdentifier] Identifier of the item associated with this issue.
        attribute(:identifier, ItemIdentifier, null: false)

        # @return [String] Issue description.
        attribute(:message, String, null: false)

        # @return [String] Issue severity level.
        attribute(:severity, String, null: false)
      end
    end
  end
end
