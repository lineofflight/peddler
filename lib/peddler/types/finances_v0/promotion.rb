# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FinancesV0
      # A promotion applied to an item.
      Promotion = Structure.new do
        # @return [Money] The amount of promotional discount applied to the item.
        attribute?(:promotion_amount, Money, from: "PromotionAmount")

        # @return [String] The seller-specified identifier for the promotion.
        attribute?(:promotion_id, String, from: "PromotionId")

        # @return [String] The type of promotion.
        attribute?(:promotion_type, String, from: "PromotionType")
      end
    end
  end
end
