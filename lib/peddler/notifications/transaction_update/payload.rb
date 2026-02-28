# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [TransactionUpdateNotification]
        attribute(:transaction_update_notification, TransactionUpdateNotification, null: false, from: "TransactionUpdateNotification")
      end
    end
  end
end
