# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # The response schema for the `getActionItem` operation.
      GetActionItemResponse = Structure.new do
        attribute(:action_item, ActionItem, null: false, from: "actionItem")
      end
    end
  end
end
