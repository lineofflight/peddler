# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A shipment, refund, guarantee claim, or chargeback.
      ShipmentEvent = Structure.new do
        # An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # A list of transactions where buyers pay Amazon through one of the credit cards offered by Amazon or where
        # buyers pay a seller directly through COD.
        attribute?(:direct_payment_list, [DirectPayment], from: "DirectPaymentList")

        # The name of the marketplace where the event occurred.
        attribute?(:marketplace_name, String, from: "MarketplaceName")

        # A list of order-level charge adjustments. These adjustments are applicable to Multi-Channel Fulfillment COD
        # orders.
        attribute?(:order_charge_adjustment_list, [ChargeComponent], from: "OrderChargeAdjustmentList")

        # A list of order-level charges. These charges are applicable to Multi-Channel Fulfillment COD orders.
        attribute?(:order_charge_list, [ChargeComponent], from: "OrderChargeList")

        # A list of order-level fee adjustments. These adjustments are applicable to Multi-Channel Fulfillment orders.
        attribute?(:order_fee_adjustment_list, [FeeComponent], from: "OrderFeeAdjustmentList")

        # A list of order-level fees. These charges are applicable to Multi-Channel Fulfillment orders.
        attribute?(:order_fee_list, [FeeComponent], from: "OrderFeeList")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # A seller-defined identifier for an order.
        attribute?(:seller_order_id, String, from: "SellerOrderId")

        # A list of shipment-level fee adjustments.
        attribute?(:shipment_fee_adjustment_list, [FeeComponent], from: "ShipmentFeeAdjustmentList")

        # A list of shipment-level fees.
        attribute?(:shipment_fee_list, [FeeComponent], from: "ShipmentFeeList")

        # A list of shipment item adjustments.
        attribute?(:shipment_item_adjustment_list, [ShipmentItem], from: "ShipmentItemAdjustmentList")

        attribute?(:shipment_item_list, [ShipmentItem], from: "ShipmentItemList")

        # The name of the store where the event occurred.
        attribute?(:store_name, String, from: "StoreName")
      end
    end
  end
end
