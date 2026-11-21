# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Additional information about an item in a transaction.
      Item = Structure.new do
        # A list of breakdowns that detail how the total amount is calculated for the transaction.
        attribute?(:breakdowns, [Breakdown])

        # Additional Information about the item.
        attribute?(:contexts, [Context])

        # A description of the items in a transaction.
        attribute?(:description, String)

        # Related business identifiers of the item.
        attribute?(:related_identifiers, [ItemRelatedIdentifier], from: "relatedIdentifiers")

        # The total monetary amount of the item.
        attribute?(:total_amount, Money, from: "totalAmount")
      end
    end
  end
end
