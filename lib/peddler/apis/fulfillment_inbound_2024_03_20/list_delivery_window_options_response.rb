# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listDeliveryWindowOptions` response.
      ListDeliveryWindowOptionsResponse = Structure.new do
        # @return [Array<DeliveryWindowOption>] Delivery window options generated for the placement option.
        attribute(:delivery_window_options, [DeliveryWindowOption], null: false, from: "deliveryWindowOptions")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
