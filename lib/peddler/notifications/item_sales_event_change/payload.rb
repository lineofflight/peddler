# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemSalesEventChange
      # Notification payload data
      Payload = Structure.new do
        # @return [Array<ItemSalesEventChange>]
        attribute(:item_sales_event_changes, [ItemSalesEventChange], from: "itemSalesEventChanges")
      end
    end
  end
end
