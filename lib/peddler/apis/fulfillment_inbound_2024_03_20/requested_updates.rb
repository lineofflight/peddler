# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Objects that were included in the update request.
      RequestedUpdates = Structure.new do
        # A list of boxes that will be present in the shipment after the update.
        attribute?(:boxes, [BoxUpdateInput])

        # A list of all items that will be present in the shipment after the update.
        attribute?(:items, [ItemInput])
      end
    end
  end
end
