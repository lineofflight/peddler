# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ItemInventoryEventChange
      # Notification payload data
      Payload = Structure.new do
        # @return [Array<ItemInventoryEventChange>]
        attribute(:item_inventory_event_changes, [ItemInventoryEventChange], null: false, from: "itemInventoryEventChanges")
      end
    end
  end
end
