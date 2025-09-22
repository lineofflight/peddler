# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # A promotion applied to an item.
      Promotion = Structure.new do
        # @return [String] The type of promotion.
        attribute(:promotion_type, String, from: "PromotionType")

        # @return [String] The seller-specified identifier for the promotion.
        attribute(:promotion_id, String, from: "PromotionId")

        # @return [Money] The amount of promotional discount applied to the item.
        attribute(:promotion_amount, Money, from: "PromotionAmount")
      end
    end
  end
end
