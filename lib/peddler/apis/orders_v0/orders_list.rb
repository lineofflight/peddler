# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # A list of orders along with additional information to make subsequent API calls.
      OrdersList = Structure.new do
        # @return [Array<Order>]
        attribute(:orders, [Order], null: false, from: "Orders")

        # @return [String] Use this date to select orders created before (or at) a specified time. Only orders placed
        #   before the specified time are returned. The date must be in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:created_before, String, from: "CreatedBefore")

        # @return [String] Use this date to select orders that were last updated before (or at) a specified time. An
        #   update is defined as any change in order status, including the creation of a new order. Includes updates
        #   made by Amazon and by the seller. Use [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
        #   format for all dates.
        attribute?(:last_updated_before, String, from: "LastUpdatedBefore")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        #   response page.
        attribute?(:next_token, String, from: "NextToken")
      end
    end
  end
end
