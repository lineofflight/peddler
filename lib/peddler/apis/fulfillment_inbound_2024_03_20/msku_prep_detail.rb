# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # An MSKU and its related prep details.
      MskuPrepDetail = Structure.new do
        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String, null: false)

        # @return [String]
        attribute(:prep_category, String, null: false, from: "prepCategory")

        # @return [Array<PrepType>] A list of preparation types associated with a preparation category.
        attribute(:prep_types, Array, null: false, from: "prepTypes")

        # @return [String]
        attribute?(:all_owners_constraint, String, from: "allOwnersConstraint")

        # @return [String]
        attribute?(:label_owner_constraint, String, from: "labelOwnerConstraint")

        # @return [String]
        attribute?(:prep_owner_constraint, String, from: "prepOwnerConstraint")
      end
    end
  end
end
