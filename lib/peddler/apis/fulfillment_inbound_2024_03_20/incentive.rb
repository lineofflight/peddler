# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains details about cost related modifications to the placement cost.
      Incentive = Structure.new do
        # Description of the incentive.
        attribute(:description, String, null: false)

        # Target of the incentive. Possible values: 'Placement Services', 'Fulfillment Fee Discount'.
        attribute(:target, String, null: false)

        # Type of incentive. Possible values: `FEE`, `DISCOUNT`.
        attribute(:type, String, null: false)

        attribute(:value, Money, null: false)
      end
    end
  end
end
