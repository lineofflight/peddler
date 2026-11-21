# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Orders
    #
    # Use the Orders Selling Partner API to programmatically retrieve order information. With this API, you can develop
    # fast, flexible, and custom applications to manage order synchronization, perform order research, and create
    # demand-based decision support tools.
    #
    # _Note:_ For the JP, AU, and SG marketplaces, the Orders API supports orders from 2016 onward. For all other
    # marketplaces, the Orders API supports orders for the last two years (orders older than this don't show up in the
    # response).
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/orders-api-model/ordersV0.json
    module OrdersV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "orders_v0.get_order" => -> { GetOrderResponse },
        "orders_v0.get_order_address" => -> { GetOrderAddressResponse },
        "orders_v0.get_order_buyer_info" => -> { GetOrderBuyerInfoResponse },
        "orders_v0.get_order_items" => -> { GetOrderItemsResponse },
        "orders_v0.get_order_items_buyer_info" => -> { GetOrderItemsBuyerInfoResponse },
        "orders_v0.get_order_regulated_info" => -> { GetOrderRegulatedInfoResponse },
        "orders_v0.get_orders" => -> { GetOrdersResponse },
      })
    end
  end
end
