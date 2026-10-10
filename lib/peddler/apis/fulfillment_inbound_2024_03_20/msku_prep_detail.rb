# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # An MSKU and its related prep details.
      MskuPrepDetail = Structure.new do
        # The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String, null: false)

        attribute(:prep_category, String, null: false, from: "prepCategory")

        # A list of preparation types associated with a preparation category.
        attribute(:prep_types, Array, null: false, from: "prepTypes")

        attribute?(:all_owners_constraint, String, from: "allOwnersConstraint")

        attribute?(:label_owner_constraint, String, from: "labelOwnerConstraint")

        attribute?(:prep_owner_constraint, String, from: "prepOwnerConstraint")
      end
    end
  end
end
