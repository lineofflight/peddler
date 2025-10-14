# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An item from a SAFE-T claim reimbursement.
      SAFETReimbursementItem = Structure.new do
        # @return [Array<ChargeComponent>] A list of charges associated with the item.
        attribute?(:item_charge_list, [ChargeComponent], from: "itemChargeList")

        # @return [String] The description of the item as shown on the product detail page on the retail website.
        attribute?(:product_description, String, from: "productDescription")

        # @return [String] The number of units of the item being reimbursed.
        attribute?(:quantity, String)
      end
    end
  end
end
