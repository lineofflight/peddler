# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The information required by a selling partner to issue a shipment invoice.
      ShipmentDetail = Structure.new do
        # The Amazon-defined identifier for the order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # The Amazon-defined identifier for the shipment.
        attribute?(:amazon_shipment_id, String, from: "AmazonShipmentId")

        # The county of the buyer.
        attribute?(:buyer_county, String, from: "BuyerCounty")

        # The name of the buyer.
        attribute?(:buyer_name, String, from: "BuyerName")

        attribute?(:buyer_tax_info, BuyerTaxInfo, from: "BuyerTaxInfo")

        # The identifier for the marketplace where the order was placed.
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        attribute?(:marketplace_tax_info, MarketplaceTaxInfo, from: "MarketplaceTaxInfo")

        attribute?(:payment_method_details, [String], from: "PaymentMethodDetails")

        attribute?(:payments, [PaymentInformation], from: "Payments")

        # The date and time when the order was created.
        attribute?(:purchase_date, Time, from: "PurchaseDate")

        # The seller’s friendly name registered in the marketplace.
        attribute?(:seller_display_name, String, from: "SellerDisplayName")

        # The seller identifier.
        attribute?(:seller_id, String, from: "SellerId")

        attribute?(:shipment_items, [ShipmentItem], from: "ShipmentItems")

        attribute?(:shipping_address, Address, from: "ShippingAddress")

        # The Amazon-defined identifier for the warehouse.
        attribute?(:warehouse_id, String, from: "WarehouseId")
      end
    end
  end
end
