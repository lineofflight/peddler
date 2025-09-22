# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/address"

module Peddler
  module Types
    module SupplySources20200701
      # A request to create a supply source.
      CreateSupplySourceRequest = Structure.new do
        # @return [String]
        attribute(:supply_source_code, String, from: "supplySourceCode")

        # @return [String]
        attribute(:alias, String)

        # @return [Address]
        attribute(:address, Address)
      end
    end
  end
end
