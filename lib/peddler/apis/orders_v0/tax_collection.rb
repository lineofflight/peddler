# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Information about withheld taxes.
      TaxCollection = Structure.new do
        # @return [String] The tax collection model applied to the item.
        attribute?(:model, String, from: "Model")

        # @return [String] The party responsible for withholding the taxes and remitting them to the taxing authority.
        attribute?(:responsible_party, String, from: "ResponsibleParty")
      end
    end
  end
end
