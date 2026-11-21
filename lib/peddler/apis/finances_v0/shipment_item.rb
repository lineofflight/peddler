# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An item of a shipment, refund, guarantee claim, or chargeback.
      ShipmentItem = Structure.new do
        # The cost of Amazon Points granted for a shipment item.
        attribute?(:cost_of_points_granted, Money, from: "CostOfPointsGranted")

        # The cost of Amazon Points returned for a shipment item. This value is only returned for refunds, guarantee
        # claims, and chargeback events.
        attribute?(:cost_of_points_returned, Money, from: "CostOfPointsReturned")

        # A list of charge adjustments associated with the shipment item. This value is only returned for refunds,
        # guarantee claims, and chargeback events.
        attribute?(:item_charge_adjustment_list, [ChargeComponent], from: "ItemChargeAdjustmentList")

        # A list of charges associated with the shipment item.
        attribute?(:item_charge_list, [ChargeComponent], from: "ItemChargeList")

        # A list of fee adjustments associated with the shipment item. This value is only returned for refunds,
        # guarantee claims, and chargeback events.
        attribute?(:item_fee_adjustment_list, [FeeComponent], from: "ItemFeeAdjustmentList")

        # A list of fees associated with the shipment item.
        attribute?(:item_fee_list, [FeeComponent], from: "ItemFeeList")

        # A list of taxes withheld information for a shipment item.
        attribute?(:item_tax_withheld_list, [TaxWithheldComponent], from: "ItemTaxWithheldList")

        # An Amazon-defined order adjustment identifier defined for refunds, guarantee claims, and chargeback events.
        attribute?(:order_adjustment_item_id, String, from: "OrderAdjustmentItemId")

        # An Amazon-defined order item identifier.
        attribute?(:order_item_id, String, from: "OrderItemId")

        # A list of promotion adjustments associated with the shipment item. This value is only returned for refunds,
        # guarantee claims, and chargeback events.
        attribute?(:promotion_adjustment_list, [Promotion], from: "PromotionAdjustmentList")

        attribute?(:promotion_list, [Promotion], from: "PromotionList")

        # The number of items shipped.
        attribute?(:quantity_shipped, Integer, from: "QuantityShipped")

        # The seller SKU of the item. The seller SKU is qualified by the seller's seller ID, which is included with
        # every call to the Selling Partner API.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
