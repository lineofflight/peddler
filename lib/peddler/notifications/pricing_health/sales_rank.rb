# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      SalesRank = Structure.new do
        # @return [String] The product category for the rank
        attribute(:product_category_id, String, from: "productCategoryId")

        # @return [Integer] The sales rank of the ASIN
        attribute(:rank, Integer)
      end
    end
  end
end
