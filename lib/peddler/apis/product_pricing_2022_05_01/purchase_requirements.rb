# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Purchase requirements that customers must meet to qualify for basket building promotions. Contains the purchase
      # condition (how much to buy). Represents the 'Buy X' portion of Buy X Get Y promotions.
      PurchaseRequirements = Structure.new do
        # @return [PurchaseCondition] Minimum purchase requirement specifying either quantity of items or total spend
        #   amount that customers must meet to qualify.
        attribute?(:condition, PurchaseCondition)
      end
    end
  end
end
