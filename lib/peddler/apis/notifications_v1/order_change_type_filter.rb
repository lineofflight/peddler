# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # An event filter to customize your subscription to send notifications for only the specified `orderChangeType`.
      OrderChangeTypeFilter = Structure.new do
        # @return [Array<OrderChangeTypeEnum>]
        attribute?(:order_change_types, Array, from: "orderChangeTypes")
      end
    end
  end
end
