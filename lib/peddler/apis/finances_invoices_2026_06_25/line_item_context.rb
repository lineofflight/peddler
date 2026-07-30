# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # Contextual information about an invoice line item.
      LineItemContext = Structure.new do
        # @return [String] The type of line item.
        attribute(:line_item_type, String, null: false, from: "lineItemType")

        # @return [String] A description of the item.
        attribute?(:item_description, String, from: "itemDescription")

        # @return [Array<ItemIdentifier>] A list of identifiers for the item.
        attribute?(:item_identifiers, [ItemIdentifier], from: "itemIdentifiers")

        # @return [MatchingContext] Information related to matching of invoiced quantity with Amazon systems.
        attribute?(:matching_context, MatchingContext, from: "matchingContext")

        # @return [ServiceChargePeriod] The service charge period.
        attribute?(:service_charge_period, ServiceChargePeriod, from: "serviceChargePeriod")

        # @return [String] The type of service charge.
        attribute?(:service_charge_type, String, from: "serviceChargeType")
      end
    end
  end
end
