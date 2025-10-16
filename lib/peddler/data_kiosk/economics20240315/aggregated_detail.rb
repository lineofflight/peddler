# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The aggregated transaction detail for the seller's account aggregated by
      # transaction event type and transaction type, for example: charge and
      # "fbaFulfillmentFee".
      AggregatedDetail = Structure.new do
        # @return [Amount] Amount calculated by rate card.
        attribute?(:amount, Amount)

        # @return [Amount] Final charge amount per unit after promotion and tax are considered. This
        # value is calculated by dividing totalAmount by quantity. This value will be
        # null when quantity is null.
        attribute?(:amount_per_unit, Amount, from: "amountPerUnit")

        # @return [Amount] The per unit amount delta is calculated by subtracting the previous
        # amountPerUnit from the current amountPerUnit. This value is mainly used to
        # indicate the change in amountPerUnit before and after an Amazon fee change.
        # This value will be null if there are no Amazon fee change in the selected time
        # range or if the previous amountPerUnit is null.
        # Example: if the previous amountPerUnit is $5 and the current amountPerUnit is $7, the amountPerUnitDelta would
        # be $2.
        attribute?(:amount_per_unit_delta, Amount, from: "amountPerUnitDelta")

        # @return [Amount] The promotion amount associated with this transaction type. This value is deducted from
        # amount when computing totalAmount.
        attribute?(:promotion_amount, Amount, from: "promotionAmount")

        # @return [Float] Charged quantity for a given product in the seller's account. When the fee is
        # not charged on a per unit basis, this value may be null or may not be an integer.
        attribute?(:quantity, Float)

        # @return [Amount] The tax amount associated with this transaction type. This value is added to amount when
        # computing totalAmount.
        attribute?(:tax_amount, Amount, from: "taxAmount")

        # @return [Amount] Final charge amount after promotion and tax are considered. This value is
        # calculated as amount - promotionAmount + taxAmount.
        attribute?(:total_amount, Amount, from: "totalAmount")
      end
    end
  end
end
