# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Tax collection information for an order item.
      ItemTaxCollection = Structure.new do
        # @return [String] The tax collection model applied to the item.
        #
        # **Possible values**:
        # - `MARKETPLACE_FACILITATOR` (Tax is withheld and remitted to the taxing authority by Amazon on behalf of the
        #   seller)
        attribute?(:model, String)

        # @return [String] The party responsible for withholding the taxes and remitting them to the taxing authority.
        attribute?(:responsible_party, String, from: "responsibleParty")
      end
    end
  end
end
