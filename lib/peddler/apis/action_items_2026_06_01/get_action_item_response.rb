# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # The response schema for the `getActionItem` operation.
      GetActionItemResponse = Structure.new do
        # @return [ActionItem]
        attribute(:action_item, ActionItem, null: false, from: "actionItem")
      end
    end
  end
end
