# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # A collection of order items that are to be fulfilled from the same location with the same shipping, pickup, and
      # service instructions.
      FulfillmentPlan = Structure.new do
        # @return [String] Time when the fulfillment plan was created in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:creation_date, String, from: "CreationDate")

        # @return [String] Unique identifier for a fulfillment plan.
        attribute(:fulfillment_plan_id, String, from: "FulfillmentPlanId")

        # @return [Array<FulfillmentPlanItem>] The details of the order items that are included in the fulfillment plan.
        attribute(:fulfillment_plan_items, [FulfillmentPlanItem], from: "FulfillmentPlanItems")

        # @return [String] The fulfillment plan status.
        attribute(:fulfillment_plan_status, String, from: "FulfillmentPlanStatus")

        # @return [String] Type of fulfillment
        attribute(:fulfillment_type, String, from: "FulfillmentType")

        # @return [String] The time when the fulfillment plan's status was last updated in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute(:last_status_update_date, String, from: "LastStatusUpdateDate")

        # @return [FulfillmentLocation] Represents the location where the plan is fulfilled.
        attribute?(:fulfillment_location, FulfillmentLocation, from: "FulfillmentLocation")

        # @return [ShippingInstructions] The shipping-related information for a delivery.
        attribute?(:shipping_instructions, ShippingInstructions, from: "ShippingInstructions")
      end
    end
  end
end
