# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/item_related_identifier"
require "peddler/types/finances_2024_06_19/currency"
require "peddler/types/finances_2024_06_19/breakdown"
require "peddler/types/finances_2024_06_19/context"

module Peddler
  module Types
    module Finances20240619
      # Additional information about the items in Transaction.
      Item = Structure.new do
        # @return [String] Description of items in the transaction
        attribute(:description, String)

        # @return [Array<ItemRelatedIdentifier>] Related business identifiers of the item.
        attribute(:related_identifiers, [ItemRelatedIdentifier], from: "relatedIdentifiers")

        # @return [Currency] The total amount of the item.
        attribute(:total_amount, Currency, from: "totalAmount")

        # @return [Array<Breakdown>] A list of breakdowns that detail how the total amount is calculated for the
        # transaction.
        attribute(:breakdowns, [Breakdown])

        # @return [Array<Context>] Additional Information about the item.
        attribute(:contexts, [Context])
      end
    end
  end
end
