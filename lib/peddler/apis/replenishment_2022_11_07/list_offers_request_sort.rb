# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # Use these parameters to sort the response.
      ListOffersRequestSort = Structure.new do
        # @return [String] The attribute to use to sort the results. Known values: `ASIN`,
        #   `SELLING_PARTNER_FUNDED_BASE_DISCOUNT_PERCENTAGE`, `SELLING_PARTNER_FUNDED_TIERED_DISCOUNT_PERCENTAGE`,
        #   `AMAZON_FUNDED_BASE_DISCOUNT_PERCENTAGE`, `AMAZON_FUNDED_TIERED_DISCOUNT_PERCENTAGE`, `INVENTORY`, `PRICE`,
        #   `SUBSCRIPTION_COUNT`, `FULFILLMENT_NETWORK_ID_TYPE`.
        attribute(:key, String, null: false)

        # @return [String] The sort order. Known values: `ASC`, `DESC`.
        attribute(:order, String, null: false)
      end
    end
  end
end
