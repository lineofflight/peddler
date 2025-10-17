# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Details about what caused this ORDER_CHANGE notification to be sent.
      OrderChangeTrigger = Structure.new do
        # @return [String] The reason this ORDER_CHANGE notification was sent.
        attribute(:change_reason, String, from: "ChangeReason")

        # @return [String] The time of the change that caused this notification, in ISO-8601 date/time format. Will be
        #   null when there is no related timestamp.
        attribute(:time_of_order_change, String, from: "TimeOfOrderChange")
      end
    end
  end
end
