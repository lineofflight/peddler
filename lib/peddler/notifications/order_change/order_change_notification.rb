# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Nested notification data
      OrderChangeNotification = Structure.new do
        # The Amazon order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, null: false, from: "AmazonOrderId")

        # The notification level of current notification. Known values: `OrderItemLevel`, `OrderLevel`.
        attribute(:notification_level, String, null: false, from: "NotificationLevel")

        attribute(:order_change_trigger, OrderChangeTrigger, null: false, from: "OrderChangeTrigger")

        # Change type of this notification. The possible values include BuyerRequestedChange, DeliveryTipChange,
        # OrderStatusChange.
        attribute(:order_change_type, String, null: false, from: "OrderChangeType")

        # The selling partner identifier.
        attribute(:seller_id, String, null: false, from: "SellerId")

        attribute(:summary, Summary, null: false, from: "Summary")
      end
    end
  end
end
