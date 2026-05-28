# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Details about what triggered this ORDER_CHANGE notification.
      OrderChangeTrigger = Structure.new do
        # @return [String] The reason for this ORDER_CHANGE notification.
        attribute(:change_reason, String, null: false, from: "ChangeReason")

        # @return [String] The timestamp for the change that caused this notification, presented in ISO-8601 date/time
        #   format. It will be null when there is no related timestamp.
        attribute(:time_of_order_change, String, from: "TimeOfOrderChange")
      end
    end
  end
end
