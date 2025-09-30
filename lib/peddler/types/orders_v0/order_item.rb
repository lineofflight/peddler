# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/orders_v0/associated_item"
require "peddler/types/orders_v0/product_info_detail"
require "peddler/types/orders_v0/points_granted_detail"
require "peddler/types/orders_v0/tax_collection"
require "peddler/types/orders_v0/item_buyer_info"
require "peddler/types/orders_v0/buyer_requested_cancel"
require "peddler/types/orders_v0/substitution_preferences"
require "peddler/types/orders_v0/measurement"
require "peddler/types/orders_v0/shipping_constraints"
require "peddler/types/orders_v0/amazon_programs"

module Peddler
  module Types
    module OrdersV0
      # A single order item.
      OrderItem = Structure.new do
        # @return [String] The item's Amazon Standard Identification Number (ASIN).
        attribute(:asin, String, from: "ASIN")

        # @return [String] The item's seller stock keeping unit (SKU).
        attribute?(:seller_sku, String, from: "SellerSKU")

        # @return [String] An Amazon-defined order item identifier.
        attribute(:order_item_id, String, from: "OrderItemId")

        # @return [Array<AssociatedItem>] A list of associated items that a customer has purchased with a product. For
        # example, a tire installation service purchased with tires.
        attribute?(:associated_items, [AssociatedItem], from: "AssociatedItems")

        # @return [String] The item's name.
        attribute?(:title, String, from: "Title")

        # @return [Integer] The number of items in the order.
        attribute(:quantity_ordered, Integer, from: "QuantityOrdered")

        # @return [Integer] The number of items shipped.
        attribute?(:quantity_shipped, Integer, from: "QuantityShipped")

        # @return [ProductInfoDetail] The item's product information.
        attribute?(:product_info, ProductInfoDetail, from: "ProductInfo")

        # @return [PointsGrantedDetail] The number and value of Amazon Points granted with the purchase of an item.
        attribute?(:points_granted, PointsGrantedDetail, from: "PointsGranted")

        # @return [Money] The selling price of the order item. Note that an order item is an item and a quantity. This
        # means that the value of `ItemPrice` is equal to the selling price of the item multiplied by the quantity
        # ordered. `ItemPrice` excludes `ShippingPrice` and GiftWrapPrice.
        attribute?(:item_price, Money, from: "ItemPrice")

        # @return [Money] The item's shipping price.
        attribute?(:shipping_price, Money, from: "ShippingPrice")

        # @return [Money] The tax on the item price.
        attribute?(:item_tax, Money, from: "ItemTax")

        # @return [Money] The tax on the shipping price.
        attribute?(:shipping_tax, Money, from: "ShippingTax")

        # @return [Money] The discount on the shipping price.
        attribute?(:shipping_discount, Money, from: "ShippingDiscount")

        # @return [Money] The tax on the discount on the shipping price.
        attribute?(:shipping_discount_tax, Money, from: "ShippingDiscountTax")

        # @return [Money] The total of all promotional discounts in the offer.
        attribute?(:promotion_discount, Money, from: "PromotionDiscount")

        # @return [Money] The tax on the total of all promotional discounts in the offer.
        attribute?(:promotion_discount_tax, Money, from: "PromotionDiscountTax")

        # @return [Array<String>]
        attribute?(:promotion_ids, [String], from: "PromotionIds")

        # @return [Money] The fee charged for COD service.
        attribute?(:cod_fee, Money, from: "CODFee")

        # @return [Money] The discount on the COD fee.
        attribute?(:cod_fee_discount, Money, from: "CODFeeDiscount")

        # @return [String] Indicates whether the item is a gift.
        #
        # **Possible values**: `true` and `false`.
        attribute?(:is_gift, String, from: "IsGift")

        # @return [String] The condition of the item, as described by the seller.
        attribute?(:condition_note, String, from: "ConditionNote")

        # @return [String] The condition of the item.
        #
        # **Possible values**: `New`, `Used`, `Collectible`, `Refurbished`, `Preorder`, and `Club`.
        attribute?(:condition_id, String, from: "ConditionId")

        # @return [String] The subcondition of the item.
        #
        # **Possible values**: `New`, `Mint`, `Very Good`, `Good`, `Acceptable`, `Poor`, `Club`, `OEM`, `Warranty`,
        # `Refurbished Warranty`, `Refurbished`, `Open Box`, `Any`, and `Other`.
        attribute?(:condition_subtype_id, String, from: "ConditionSubtypeId")

        # @return [String] The start date of the scheduled delivery window in the time zone for the order destination.
        # In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:scheduled_delivery_start_date, String, from: "ScheduledDeliveryStartDate")

        # @return [String] The end date of the scheduled delivery window in the time zone for the order destination. In
        # [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:scheduled_delivery_end_date, String, from: "ScheduledDeliveryEndDate")

        # @return [String] Indicates that the selling price is a special price that is only available for Amazon
        # Business orders. For more information about the Amazon Business Seller Program, refer to the [Amazon Business
        # website](https://www.amazon.com/b2b/info/amazon-business).
        #
        # **Possible values**: `BusinessPrice`
        attribute?(:price_designation, String, from: "PriceDesignation")

        # @return [TaxCollection] Information about withheld taxes.
        attribute?(:tax_collection, TaxCollection, from: "TaxCollection")

        # @return [:boolean] When true, the product type for this item has a serial number.
        #
        # Only returned for Amazon Easy Ship orders.
        attribute?(:serial_number_required, :boolean, from: "SerialNumberRequired")

        # @return [:boolean] When true, the ASIN is enrolled in Transparency. The Transparency serial number that you
        # must submit is determined by:
        #
        # **1D or 2D Barcode:** This has a **T** logo. Submit either the 29-character alpha-numeric identifier beginning
        # with **AZ** or **ZA**, or the 38-character Serialized Global Trade Item Number (SGTIN).
        # **2D Barcode SN:** Submit the 7- to 20-character serial number barcode, which likely has the prefix **SN**.
        # The serial number is applied to the same side of the packaging as the GTIN (UPC/EAN/ISBN) barcode.
        # **QR code SN:** Submit the URL that the QR code generates.
        attribute?(:transparency, :boolean, from: "IsTransparency")

        # @return [String] The IOSS number of the marketplace. Sellers shipping to the EU from outside the EU must
        # provide this IOSS number to their carrier when Amazon has collected the VAT on the sale.
        attribute?(:ioss_number, String, from: "IossNumber")

        # @return [String] The store chain store identifier. Linked to a specific store in a store chain.
        attribute?(:store_chain_store_id, String, from: "StoreChainStoreId")

        # @return [String] The category of deemed reseller. This applies to selling partners that are not based in the
        # EU and is used to help them meet the VAT Deemed Reseller tax laws in the EU and UK.
        attribute?(:deemed_reseller_category, String, from: "DeemedResellerCategory")

        # @return [ItemBuyerInfo] A single item's buyer information.
        #
        # **Note**: The `BuyerInfo` contains restricted data. Use the Restricted Data Token (RDT) and restricted SPDS
        # roles to access the restricted data in `BuyerInfo`. For example, `BuyerCustomizedInfo` and `GiftMessageText`.
        attribute?(:buyer_info, ItemBuyerInfo, from: "BuyerInfo")

        # @return [BuyerRequestedCancel] Information about whether or not a buyer requested cancellation.
        attribute?(:buyer_requested_cancel, BuyerRequestedCancel, from: "BuyerRequestedCancel")

        # @return [Array<String>] A list of serial numbers for electronic products that are shipped to customers.
        # Returned for FBA orders only.
        attribute?(:serial_numbers, [String], from: "SerialNumbers")

        # @return [SubstitutionPreferences] Substitution preferences for the order item. This is an optional field that
        # is only present if a seller supports substitutions, as is the case with some grocery sellers.
        attribute?(:substitution_preferences, SubstitutionPreferences, from: "SubstitutionPreferences")

        # @return [Measurement] Measurement information for the order item.
        attribute?(:measurement, Measurement, from: "Measurement")

        # @return [ShippingConstraints] Shipping constraints applicable to this order.
        attribute?(:shipping_constraints, ShippingConstraints, from: "ShippingConstraints")

        # @return [AmazonPrograms] Contains the list of programs that are associated with an item.
        attribute?(:amazon_programs, AmazonPrograms, from: "AmazonPrograms")
      end
    end
  end
end
