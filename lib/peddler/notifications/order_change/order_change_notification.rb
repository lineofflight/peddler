# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Nested notification data
      OrderChangeNotification = Structure.new do
        # @return [String] The Amazon order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] The notification level of current notification.
        attribute(:notification_level, String, from: "NotificationLevel")

        # @return [OrderChangeTrigger]
        attribute(:order_change_trigger, OrderChangeTrigger, from: "OrderChangeTrigger")

        # @return [String] The type of order change that caused the notification to be sent. Possible values are
        # BuyerRequestedChange and OrderStatusChange.
        attribute(:order_change_type, String, from: "OrderChangeType")

        # @return [String] The selling partner identifier.
        attribute(:seller_id, String, from: "SellerId")

        # @return [Summary]
        attribute(:summary, Summary, from: "Summary")
      end
    end
  end
end
