# frozen_string_literal: true

require "peddler/types/shipment_invoicing_v0/address"
require "peddler/types/shipment_invoicing_v0/payment_information"
require "peddler/types/shipment_invoicing_v0/buyer_tax_info"
require "peddler/types/shipment_invoicing_v0/marketplace_tax_info"
require "peddler/types/shipment_invoicing_v0/shipment_item"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The information required by a selling partner to issue a shipment invoice.
      ShipmentDetail = Structure.new do
        # @return [String] The Amazon-defined identifier for the warehouse.
        attribute(:warehouse_id, String, from: "WarehouseId")

        # @return [String] The Amazon-defined identifier for the order.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] The Amazon-defined identifier for the shipment.
        attribute(:amazon_shipment_id, String, from: "AmazonShipmentId")

        # @return [String] The date and time when the order was created.
        attribute(:purchase_date, String, from: "PurchaseDate")

        # @return [Address]
        attribute(:shipping_address, Address, from: "ShippingAddress")

        # @return [Array]
        attribute(:payment_method_details, Array, from: "PaymentMethodDetails")

        # @return [Array<PaymentInformation>]
        attribute(:payments, [PaymentInformation], from: "Payments")

        # @return [String] The identifier for the marketplace where the order was placed.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The seller identifier.
        attribute(:seller_id, String, from: "SellerId")

        # @return [String] The name of the buyer.
        attribute(:buyer_name, String, from: "BuyerName")

        # @return [String] The county of the buyer.
        attribute(:buyer_county, String, from: "BuyerCounty")

        # @return [BuyerTaxInfo]
        attribute(:buyer_tax_info, BuyerTaxInfo, from: "BuyerTaxInfo")

        # @return [MarketplaceTaxInfo]
        attribute(:marketplace_tax_info, MarketplaceTaxInfo, from: "MarketplaceTaxInfo")

        # @return [String] The seller’s friendly name registered in the marketplace.
        attribute(:seller_display_name, String, from: "SellerDisplayName")

        # @return [Array<ShipmentItem>]
        attribute(:shipment_items, [ShipmentItem], from: "ShipmentItems")
      end
    end
  end
end
