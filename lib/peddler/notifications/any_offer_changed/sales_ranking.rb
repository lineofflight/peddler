# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      SalesRanking = Structure.new do
        attribute(:product_category_id, String, null: false, from: "ProductCategoryId")

        attribute(:rank, Integer, null: false, from: "Rank")
      end
    end
  end
end
