# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Information pertaining to the preparation of inbound goods.
      PrepInstruction = Structure.new do
        # @return [Money]
        attribute?(:fee, Money)

        # @return [String] In some situations, special preparations are required for items and this field reflects the
        # owner of the preparations. Options include `AMAZON`, `SELLER` or `NONE`.
        attribute?(:prep_owner, String, from: "prepOwner")

        # @return [String] Type of preparation that should be done.
        #
        # Possible values: `ITEM_LABELING`, `ITEM_BUBBLEWRAP`, `ITEM_POLYBAGGING`, `ITEM_TAPING`,
        # `ITEM_BLACK_SHRINKWRAP`, `ITEM_HANG_GARMENT`, `ITEM_BOXING`, `ITEM_SETCREAT`, `ITEM_RMOVHANG`,
        # `ITEM_SUFFOSTK`, `ITEM_CAP_SEALING`, `ITEM_DEBUNDLE`, `ITEM_SETSTK`, `ITEM_SIOC`, `ITEM_NO_PREP`, `ADULT`,
        # `BABY`, `TEXTILE`, `HANGER`, `FRAGILE`, `LIQUID`, `SHARP`, `SMALL`, `PERFORATED`, `GRANULAR`, `SET`,
        # `FC_PROVIDED`, `UNKNOWN`, `NONE`.
        attribute?(:prep_type, String, from: "prepType")
      end
    end
  end
end
