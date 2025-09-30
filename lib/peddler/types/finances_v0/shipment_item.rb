# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/finances_v0/charge_component"
require "peddler/types/finances_v0/fee_component"
require "peddler/types/finances_v0/tax_withheld_component"
require "peddler/types/finances_v0/promotion"

module Peddler
  module Types
    module FinancesV0
      # An item of a shipment, refund, guarantee claim, or chargeback.
      ShipmentItem = Structure.new do
        # @return [String] The seller SKU of the item. The seller SKU is qualified by the seller's seller ID, which is
        # included with every call to the Selling Partner API.
        attribute?(:seller_sku, String, from: "SellerSKU")

        # @return [String] An Amazon-defined order item identifier.
        attribute?(:order_item_id, String, from: "OrderItemId")

        # @return [String] An Amazon-defined order adjustment identifier defined for refunds, guarantee claims, and
        # chargeback events.
        attribute?(:order_adjustment_item_id, String, from: "OrderAdjustmentItemId")

        # @return [Integer] The number of items shipped.
        attribute?(:quantity_shipped, Integer, from: "QuantityShipped")

        # @return [Array<ChargeComponent>] A list of charges associated with the shipment item.
        attribute?(:item_charge_list, [ChargeComponent], from: "ItemChargeList")

        # @return [Array<ChargeComponent>] A list of charge adjustments associated with the shipment item. This value is
        # only returned for refunds, guarantee claims, and chargeback events.
        attribute?(:item_charge_adjustment_list, [ChargeComponent], from: "ItemChargeAdjustmentList")

        # @return [Array<FeeComponent>] A list of fees associated with the shipment item.
        attribute?(:item_fee_list, [FeeComponent], from: "ItemFeeList")

        # @return [Array<FeeComponent>] A list of fee adjustments associated with the shipment item. This value is only
        # returned for refunds, guarantee claims, and chargeback events.
        attribute?(:item_fee_adjustment_list, [FeeComponent], from: "ItemFeeAdjustmentList")

        # @return [Array<TaxWithheldComponent>] A list of taxes withheld information for a shipment item.
        attribute?(:item_tax_withheld_list, [TaxWithheldComponent], from: "ItemTaxWithheldList")

        # @return [Array<Promotion>]
        attribute?(:promotion_list, [Promotion], from: "PromotionList")

        # @return [Array<Promotion>] A list of promotion adjustments associated with the shipment item. This value is
        # only returned for refunds, guarantee claims, and chargeback events.
        attribute?(:promotion_adjustment_list, [Promotion], from: "PromotionAdjustmentList")

        # @return [Money] The cost of Amazon Points granted for a shipment item.
        attribute?(:cost_of_points_granted, Money, from: "CostOfPointsGranted")

        # @return [Money] The cost of Amazon Points returned for a shipment item. This value is only returned for
        # refunds, guarantee claims, and chargeback events.
        attribute?(:cost_of_points_returned, Money, from: "CostOfPointsReturned")
      end
    end
  end
end
