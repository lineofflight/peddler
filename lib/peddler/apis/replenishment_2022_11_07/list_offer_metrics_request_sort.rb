# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # Use these parameters to sort the response.
      ListOfferMetricsRequestSort = Structure.new do
        # @return [String] Known values: `SHIPPED_SUBSCRIPTION_UNITS`, `TOTAL_SUBSCRIPTIONS_REVENUE`,
        #   `ACTIVE_SUBSCRIPTIONS`, `NEXT_90DAYS_SHIPPED_SUBSCRIPTION_UNITS`, `NEXT_60DAYS_SHIPPED_SUBSCRIPTION_UNITS`,
        #   `NEXT_30DAYS_SHIPPED_SUBSCRIPTION_UNITS`, `NEXT_90DAYS_TOTAL_SUBSCRIPTIONS_REVENUE`,
        #   `NEXT_60DAYS_TOTAL_SUBSCRIPTIONS_REVENUE`, `NEXT_30DAYS_TOTAL_SUBSCRIPTIONS_REVENUE`.
        attribute(:key, String, null: false)

        # @return [String] The sort order. Known values: `ASC`, `DESC`.
        attribute(:order, String, null: false)
      end
    end
  end
end
