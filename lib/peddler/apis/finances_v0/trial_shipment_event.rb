# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event related to a trial shipment.
      TrialShipmentEvent = Structure.new do
        # An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # A list of fees charged by Amazon for trial shipments.
        attribute?(:fee_list, [FeeComponent], from: "FeeList")

        # The identifier of the financial event group.
        attribute?(:financial_event_group_id, String, from: "FinancialEventGroupId")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The seller SKU of the item. The seller SKU is qualified by the seller's seller ID, which is included with
        # every call to the Selling Partner API.
        attribute?(:sku, String, from: "SKU")
      end
    end
  end
end
