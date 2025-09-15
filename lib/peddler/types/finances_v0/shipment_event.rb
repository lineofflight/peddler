# frozen_string_literal: true

require "peddler/types/finances_v0/charge_component"
require "peddler/types/finances_v0/fee_component"
require "peddler/types/finances_v0/direct_payment"
require "peddler/types/finances_v0/shipment_item"

module Peddler
  module Types
    module FinancesV0
      # A shipment, refund, guarantee claim, or chargeback.
      ShipmentEvent = Structure.new do
        # @return [String] An Amazon-defined identifier for an order.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] A seller-defined identifier for an order.
        attribute(:seller_order_id, String, from: "SellerOrderId")

        # @return [String] The name of the marketplace where the event occurred.
        attribute(:marketplace_name, String, from: "MarketplaceName")

        # @return [String] The name of the store where the event occurred.
        attribute(:store_name, String, from: "StoreName")

        # @return [Array<ChargeComponent>] A list of order-level charges. These charges are applicable to Multi-Channel
        # Fulfillment COD orders.
        attribute(:order_charge_list, [ChargeComponent], from: "OrderChargeList")

        # @return [Array<ChargeComponent>] A list of order-level charge adjustments. These adjustments are applicable to
        # Multi-Channel Fulfillment COD orders.
        attribute(:order_charge_adjustment_list, [ChargeComponent], from: "OrderChargeAdjustmentList")

        # @return [Array<FeeComponent>] A list of shipment-level fees.
        attribute(:shipment_fee_list, [FeeComponent], from: "ShipmentFeeList")

        # @return [Array<FeeComponent>] A list of shipment-level fee adjustments.
        attribute(:shipment_fee_adjustment_list, [FeeComponent], from: "ShipmentFeeAdjustmentList")

        # @return [Array<FeeComponent>] A list of order-level fees. These charges are applicable to Multi-Channel
        # Fulfillment orders.
        attribute(:order_fee_list, [FeeComponent], from: "OrderFeeList")

        # @return [Array<FeeComponent>] A list of order-level fee adjustments. These adjustments are applicable to
        # Multi-Channel Fulfillment orders.
        attribute(:order_fee_adjustment_list, [FeeComponent], from: "OrderFeeAdjustmentList")

        # @return [Array<DirectPayment>] A list of transactions where buyers pay Amazon through one of the credit cards
        # offered by Amazon or where buyers pay a seller directly through COD.
        attribute(:direct_payment_list, [DirectPayment], from: "DirectPaymentList")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [Array<ShipmentItem>]
        attribute(:shipment_item_list, [ShipmentItem], from: "ShipmentItemList")

        # @return [Array<ShipmentItem>] A list of shipment item adjustments.
        attribute(:shipment_item_adjustment_list, [ShipmentItem], from: "ShipmentItemAdjustmentList")
      end
    end
  end
end
