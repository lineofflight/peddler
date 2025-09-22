# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/currency"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains details about cost related modifications to the placement cost.
      Incentive = Structure.new do
        # @return [String] Description of the incentive.
        attribute(:description, String)

        # @return [String] Target of the incentive. Possible values: 'Placement Services', 'Fulfillment Fee Discount'.
        attribute(:target, String)

        # @return [String] Type of incentive. Possible values: `FEE`, `DISCOUNT`.
        attribute(:type, String)

        # @return [Currency]
        attribute(:value, Currency)
      end
    end
  end
end
