# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains details about cost related modifications to the placement cost.
      Incentive = Structure.new do
        # @return [String] Description of the incentive.
        attribute(:description, String, null: false)

        # @return [String] Target of the incentive. Possible values: 'Placement Services', 'Fulfillment Fee Discount'.
        attribute(:target, String, null: false)

        # @return [String] Type of incentive. Possible values: `FEE`, `DISCOUNT`.
        attribute(:type, String, null: false)

        # @return [Money]
        attribute(:value, Money, null: false)
      end
    end
  end
end
