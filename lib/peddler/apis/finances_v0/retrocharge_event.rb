# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A retrocharge or retrocharge reversal.
      RetrochargeEvent = Structure.new do
        # @return [String] An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [Money] The base tax associated with the retrocharge event.
        attribute?(:base_tax, Money, from: "BaseTax")

        # @return [String] The name of the marketplace where the retrocharge event occurred.
        attribute?(:marketplace_name, String, from: "MarketplaceName")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [String] The type of event.
        #
        # Possible values:
        #
        # * Retrocharge
        #
        # * RetrochargeReversal
        attribute?(:retrocharge_event_type, String, from: "RetrochargeEventType")

        # @return [Array<TaxWithheldComponent>] A list of information about taxes withheld.
        attribute?(:retrocharge_tax_withheld_list, [TaxWithheldComponent], from: "RetrochargeTaxWithheldList")

        # @return [Money] The shipping tax associated with the retrocharge event.
        attribute?(:shipping_tax, Money, from: "ShippingTax")
      end
    end
  end
end
