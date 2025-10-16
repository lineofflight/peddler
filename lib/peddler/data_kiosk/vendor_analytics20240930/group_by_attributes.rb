# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Group by attributes, essentially catalog attributes, some of which can be null, e.g., group by brand.
      GroupByAttributes = Structure.new do
        # @return [String] Amazon Standard Identification Number, used to uniquely identify products in Amazon's
        # catalog.
        attribute?(:asin, String)

        # @return [String] The format or type of the item, such as Hardcover, T-Shirt, or DVD-Audio.
        attribute?(:binding, String)

        # @return [String] Brand name.
        attribute?(:brand, String)

        # @return [String] Amazon brand code for the owning brand.
        attribute?(:brand_code, String, from: "brandCode")

        # @return [String] The color of the item, such as Red, Navy Blue, Pink, or Green.
        attribute?(:color, String)

        # @return [String] European Article Number. A 13-digit product identifier, often represented on products as a
        # barcode.
        attribute?(:ean, String)

        # @return [String] 13-digit International Standard Book Number.
        attribute?(:isbn13, String)

        # @return [String] Code used to identify the manufacturer, an entity who makes the products that are sold on
        # Amazon.
        attribute?(:manufacturer_code, String, from: "manufacturerCode")

        # @return [String] The model or style number of the product.
        attribute?(:model_number, String, from: "modelNumber")

        # @return [Amount] The manufacturer's suggested retail price (MSRP) of the item. Also known as the list price.
        attribute?(:msrp, Amount)

        # @return [String] Products with variations (size, color, etc.) have a Parent ASIN and Child
        # ASINs. The Parent ASIN represents the generic overall product
        # (non-purchasable).
        attribute?(:parent_asin, String, from: "parentAsin")

        # @return [String] Which type of prep instructions are required, e.g., ASIN stickering, Boxing, Bubble wrapping,
        # Shrinkwrap, Cap Sealing.
        attribute?(:prep_instructions, String, from: "prepInstructions")

        # @return [String] Differentiates if the prep instructions required will be performed by Amazon or the vendor.
        attribute?(:prep_instructions_performed_by, String, from: "prepInstructionsPerformedBy")

        # @return [String] The product group which describes the business group, as defined by the Amazon
        # catalog, e.g., PC, Wireless, Major Appliances.
        attribute?(:product_group, String, from: "productGroup")

        # @return [String] Product name.
        attribute?(:product_title, String, from: "productTitle")

        # @return [String] The day that an item is available for purchase by the public.
        attribute?(:release_date, String, from: "releaseDate")

        # @return [String] Availability status for the ASIN.
        attribute?(:replenishment_category, String, from: "replenishmentCategory")

        # @return [String] Customer City for a shipment.
        attribute?(:ship_to_city, String, from: "shipToCity")

        # @return [String] Customer Country Code for a shipment in ISO 3166-1 alpha-2 format.
        attribute?(:ship_to_country_code, String, from: "shipToCountryCode")

        # @return [String] Customer State or Province for a shipment.
        attribute?(:ship_to_state_or_province, String, from: "shipToStateOrProvince")

        # @return [String] The shipment destination's ZIP Code.
        attribute?(:ship_to_zip_code, String, from: "shipToZipCode")

        # @return [String] The Universal Product Code (UPC) used for retail packaging scanning at the point of sale.
        attribute?(:upc, String)

        # @return [String] The hierarchy of vendor codes (parent-child relationships) plays an important
        # role in the storage and retrieval of vendor item information, for example,
        # cost (VCS) and external IDs (VXPS).
        # Child codes are generally assumed to be ordering codes that are for the same
        # vendor, represented by the parent vendor code.
        attribute?(:vendor_code, String, from: "vendorCode")
      end
    end
  end
end
