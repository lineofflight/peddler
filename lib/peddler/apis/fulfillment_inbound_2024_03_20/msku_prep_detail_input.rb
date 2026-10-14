# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # An MSKU and its related prep details.
      MskuPrepDetailInput = Structure.new do
        # @return [String] The merchant SKU, a merchant-supplied identifier for a specific SKU.
        attribute(:msku, String, null: false)

        # @return [String] Known values: `ADULT`, `BABY`, `FC_PROVIDED`, `FRAGILE`, `GRANULAR`, `HANGER`, `LIQUID`,
        #   `PERFORATED`, `SET`, `SHARP`, `SMALL`, `TEXTILE`, `UNKNOWN`, `NONE`.
        attribute(:prep_category, String, null: false, from: "prepCategory")

        # @return [Array<PrepType>] A list of preparation types associated with a preparation category. Known values:
        #   `ITEM_BLACK_SHRINKWRAP`, `ITEM_BLANKSTK`, `ITEM_BOXING`, `ITEM_BUBBLEWRAP`, `ITEM_CAP_SEALING`,
        #   `ITEM_DEBUNDLE`, `ITEM_HANG_GARMENT`, `ITEM_LABELING`, `ITEM_NO_PREP`, `ITEM_POLYBAGGING`, `ITEM_RMOVHANG`,
        #   `ITEM_SETCREAT`, `ITEM_SETSTK`, `ITEM_SIOC`, `ITEM_SUFFOSTK`, `ITEM_TAPING`.
        attribute(:prep_types, Array, null: false, from: "prepTypes")
      end
    end
  end
end
