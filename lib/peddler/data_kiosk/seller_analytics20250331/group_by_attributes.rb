# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Group by attributes, essentially catalog attributes, some of which can be null, for example, group by brand.
      GroupByAttributes = Structure.new do
        # @return [String] Amazon Standard Identification Number, used to uniquely identify products in Amazon's
        #   catalog.
        attribute?(:asin, String)

        # @return [String] Brand name.
        attribute?(:brand, String)

        # @return [String] Amazon brand code for the owning brand.
        attribute?(:brand_code, String, from: "brandCode")

        # @return [String] Masked version of internal merchant identifier using encryption algorithm.
        attribute?(:encrypted_merchant_customer_id, String, from: "encryptedMerchantCustomerId")

        # @return [String] The fulfillment channel for the product, indicating whether it is fulfilled by Amazon (FBA)
        #   or by the seller (FBM).
        attribute?(:fulfilment_channel, String, from: "fulfilmentChannel")

        # @return [String] The marketplace identifier for the associated metrics.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Merchant Level Stock Keeping Unit.
        attribute?(:msku, String)

        # @return [String] Products with variations (size, color, etc.) have a Parent ASIN and Child ASINs. The Parent
        #   ASIN represents the generic overall product (non-purchasable).
        attribute?(:parent_asin, String, from: "parentAsin")

        # @return [String] The product group which describes the business group, as defined by the Amazon catalog, for
        #   example, PC, Wireless, Major Appliances.
        attribute?(:product_group, String, from: "productGroup")

        # @return [String] Product name.
        attribute?(:product_title, String, from: "productTitle")
      end
    end
  end
end
