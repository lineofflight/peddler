# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/delivery_window_option"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listDeliveryWindowOptions` response.
      ListDeliveryWindowOptionsResponse = Structure.new do
        # @return [Array<DeliveryWindowOption>] Delivery window options generated for the placement option.
        attribute(:delivery_window_options, [DeliveryWindowOption], from: "deliveryWindowOptions")

        # @return [Pagination]
        attribute(:pagination, Pagination)
      end
    end
  end
end
