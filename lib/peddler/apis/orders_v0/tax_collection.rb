# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Information about withheld taxes.
      TaxCollection = Structure.new do
        # The tax collection model applied to the item. Known values: `MarketplaceFacilitator`.
        attribute?(:model, String, from: "Model")

        # The party responsible for withholding the taxes and remitting them to the taxing authority. Known values:
        # `Amazon Services, Inc.`.
        attribute?(:responsible_party, String, from: "ResponsibleParty")
      end
    end
  end
end
