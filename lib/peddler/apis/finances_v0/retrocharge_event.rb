# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A retrocharge or retrocharge reversal.
      RetrochargeEvent = Structure.new do
        # An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # The base tax associated with the retrocharge event.
        attribute?(:base_tax, Money, from: "BaseTax")

        # The name of the marketplace where the retrocharge event occurred.
        attribute?(:marketplace_name, String, from: "MarketplaceName")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The type of event.
        #
        # Possible values:
        #
        # * `Retrocharge`
        #
        # * `RetrochargeReversal`
        attribute?(:retrocharge_event_type, String, from: "RetrochargeEventType")

        # A list of information about taxes withheld.
        attribute?(:retrocharge_tax_withheld_list, [TaxWithheldComponent], from: "RetrochargeTaxWithheldList")

        # The shipping tax associated with the retrocharge event.
        attribute?(:shipping_tax, Money, from: "ShippingTax")
      end
    end
  end
end
