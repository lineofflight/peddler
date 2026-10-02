# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Orders
    #
    # The Selling Partner API for Orders returns orders information. This API supports the following types of orders:
    #
    # - FBM (Fulfilled by Merchant) - FBA (Fulfilled by Amazon) - read only - Amazon Fresh
    #
    # This API does not display order data that is more than two years old, except in the JP, AU, and SG marketplaces,
    # for which data from 2016 and after is available.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/orders-api-model/orders_2026-01-01.json
    module Orders20260101
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "orders_2026_01_01.get_order" => -> { GetOrderResponse },
        "orders_2026_01_01.search_orders" => -> { SearchOrdersResponse },
      }.freeze
    end
  end
end
