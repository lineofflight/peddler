# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # A request to create a supply source.
      CreateSupplySourceRequest = Structure.new do
        # @return [Address]
        attribute(:address, Address, null: false)

        # @return [String]
        attribute(:alias, String, null: false)

        # @return [String]
        attribute(:supply_source_code, String, null: false, from: "supplySourceCode")
      end
    end
  end
end
