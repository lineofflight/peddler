# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional information about the items in Transaction.
      Item = Structure.new do
        # @return [Array<Breakdown>] A list of breakdowns that detail how the total amount is calculated for the
        # transaction.
        attribute?(:breakdowns, [Breakdown])

        # @return [Array<Context>] Additional Information about the item.
        attribute?(:contexts, [Context])

        # @return [String] Description of items in the transaction
        attribute?(:description, String)

        # @return [Array<ItemRelatedIdentifier>] Related business identifiers of the item.
        attribute?(:related_identifiers, [ItemRelatedIdentifier], from: "relatedIdentifiers")

        # @return [Money] The total amount of the item.
        attribute?(:total_amount, Money, from: "totalAmount")
      end
    end
  end
end
