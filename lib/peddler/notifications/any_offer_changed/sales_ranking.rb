# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      SalesRanking = Structure.new do
        # @return [String]
        attribute(:product_category_id, String, from: "ProductCategoryId")

        # @return [Integer]
        attribute(:rank, Integer, from: "Rank")
      end
    end
  end
end
