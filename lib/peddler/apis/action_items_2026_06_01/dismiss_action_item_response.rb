# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # The response schema for the `dismissActionItem` operation.
      DismissActionItemResponse = Structure.new do
        # @return [String] The identifier of the dismissed action item.
        attribute(:action_item_id, String, null: false, from: "actionItemId")

        # @return [Array<ActionItemStatus>] The action item's status after dismissal; contains `DISMISSED`. Known
        #   values: `PENDING_SELLING_PARTNER`, `AUTOMATABLE`, `DISMISSABLE`, `SNOOZABLE`, `DISMISSED`, `SNOOZED`,
        #   `OVERDUE`, `ACTIONED`, `RESOLVED`.
        attribute(:status, Array, null: false)
      end
    end
  end
end
