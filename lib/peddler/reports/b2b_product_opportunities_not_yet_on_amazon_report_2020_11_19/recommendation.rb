# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module B2BProductOpportunitiesNotYetOnAmazonReport20201119
      # The recommendation result object.
      Recommendation = Structure.new do
        # The brand name of the product.
        attribute?(:brand, String)

        # The primary product category.
        attribute?(:category, String)

        # The European Article Number (EAN) of the product.
        attribute?(:ean, String)

        # The industry of the first customer who requested the product.
        attribute?(:initial_b2b_buyer_industry, String, from: "initialB2bBuyerIndustry")

        # The date the product may not be on Amazon as the result of the customer request.
        attribute?(:initial_b2b_buyer_requested_date, String, from: "initialB2bBuyerRequestedDate")

        # The International Standard Book Number (ISBN) of the product.
        attribute?(:isbn, String)

        # The title of the product.
        attribute?(:item_name, String, from: "itemName")

        # The Model Number of the product.
        attribute?(:model_number, String, from: "modelNumber")

        # The Manufacturer Part Number (MPN) of the product.
        attribute?(:part_number, String, from: "partNumber")

        # The Universal Product Code (UPC) of the product.
        attribute?(:upc, String)
      end
    end
  end
end
