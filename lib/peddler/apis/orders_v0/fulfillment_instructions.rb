# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Contains all fulfillment plans for the order
      FulfillmentInstructions = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [Array<FulfillmentPlan>] List of all fulfillment plans for the given order id
        attribute?(:fulfillment_plans, [FulfillmentPlan], from: "FulfillmentPlans")
      end
    end
  end
end
