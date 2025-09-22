# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/finances_v0/tax_withheld_component"

module Peddler
  module Types
    module FinancesV0
      # A retrocharge or retrocharge reversal.
      RetrochargeEvent = Structure.new do
        # @return [String] The type of event.
        #
        # Possible values:
        #
        # * Retrocharge
        #
        # * RetrochargeReversal
        attribute(:retrocharge_event_type, String, from: "RetrochargeEventType")

        # @return [String] An Amazon-defined identifier for an order.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [Types::Money] The base tax associated with the retrocharge event.
        attribute(:base_tax, Types::Money, from: "BaseTax")

        # @return [Types::Money] The shipping tax associated with the retrocharge event.
        attribute(:shipping_tax, Types::Money, from: "ShippingTax")

        # @return [String] The name of the marketplace where the retrocharge event occurred.
        attribute(:marketplace_name, String, from: "MarketplaceName")

        # @return [Array<TaxWithheldComponent>] A list of information about taxes withheld.
        attribute(:retrocharge_tax_withheld_list, [TaxWithheldComponent], from: "RetrochargeTaxWithheldList")
      end
    end
  end
end
