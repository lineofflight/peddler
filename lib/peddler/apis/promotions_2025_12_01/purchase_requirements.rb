# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Purchase requirements that customers must meet to qualify for a basket building promotion. Contains eligibility
      # selection (what to buy), purchase condition (how much to buy), and an optional claim code. This is the 'Buy X'
      # portion of 'Buy X Get Y' promotions.
      PurchaseRequirements = Structure.new do
        # @return [PurchaseCondition] Minimum purchase requirement that specify either the quantity of items or the
        #   total spend amount that customers must meet to qualify. For multi-tier `BASKET_BUILDING` promotions, this is
        #   the first-tier purchase condition. Additional tier conditions are defined in `benefit.additionalTiers`.
        attribute(:condition, PurchaseCondition, null: false)

        # @return [Selection] Which items customers must purchase to qualify for the promotion. References the
        #   eligibility product set. This selection only contains `selectionId`, `revisionId`, and `type`; the
        #   `selectionDetails` field is not included. For some `BASKET_BUILDING` promotions, this selection may be the
        #   same as the benefit selection when purchase requirements and benefits apply to the same set of items.
        attribute(:selection, Selection, null: false)

        # @return [ClaimCode] An optional claim code customers must enter to access the promotion. When present, the
        #   promotion is code-gated and only available to customers who provide this code.
        attribute?(:claim_code, ClaimCode, from: "claimCode")
      end
    end
  end
end
