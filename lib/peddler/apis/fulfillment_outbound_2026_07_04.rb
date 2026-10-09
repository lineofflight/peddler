# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Fulfillment Outbound
    #
    # The Selling Partner API for Fulfillment Outbound lets you create applications that help a seller fulfill
    # Multi-Channel Fulfillment orders using their inventory in Amazon's fulfillment network. You can get information on
    # both potential and existing fulfillment orders.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fulfillment-outbound-api-model/fulfillmentOutbound_2026-07-04.json
    module FulfillmentOutbound20260704
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "fulfillment_outbound_2026_07_04.cancel_order" => -> { CancelOrderResponse },
        "fulfillment_outbound_2026_07_04.create_order" => -> { CreateOrderResponse },
        "fulfillment_outbound_2026_07_04.get_offers" => -> { GetOffersResponse },
        "fulfillment_outbound_2026_07_04.get_order" => -> { GetOrderResponse },
        "fulfillment_outbound_2026_07_04.get_order_preview" => -> { GetOrderPreviewResponse },
        "fulfillment_outbound_2026_07_04.list_orders" => -> { ListOrdersResponse },
        "fulfillment_outbound_2026_07_04.update_order" => -> { UpdateOrderResponse },
      })
    end
  end
end
