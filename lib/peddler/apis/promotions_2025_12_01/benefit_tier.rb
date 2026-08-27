# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Defines a progressive (multi-tier) benefit tier that applies when customers exceed a higher purchase quantity
      # for basket building promotions. Each tier specifies a purchase condition and corresponding enhanced discount.
      BenefitTier = Structure.new do
        # @return [Discount] The discount configuration for this tier.
        attribute(:discount, Discount, null: false)

        # @return [PurchaseCondition] The purchase condition that must be met to receive this tier's enhanced discount.
        attribute(:purchase_condition, PurchaseCondition, null: false, from: "purchaseCondition")
      end
    end
  end
end
