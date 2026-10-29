# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # Request body for dismissing an action item.
      DismissActionItemRequest = Structure.new do
        # @return [DismissalReason] The reason for dismissing the action item.
        attribute?(:reason, DismissalReason)
      end
    end
  end
end
