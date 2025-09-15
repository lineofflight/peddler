# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # An MSKU and its related prep details.
      MskuPrepDetailInput = Structure.new do
        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String)

        # @return [String]
        attribute(:prep_category, String, from: "prepCategory")

        # @return [Array<PrepType>] A list of preparation types associated with a preparation category.
        attribute(:prep_types, Array, from: "prepTypes")
      end
    end
  end
end
