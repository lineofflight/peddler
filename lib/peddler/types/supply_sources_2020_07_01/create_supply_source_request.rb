# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/supply_sources_2020_07_01/address"

module Peddler
  module Types
    module SupplySources20200701
      # A request to create a supply source.
      CreateSupplySourceRequest = Structure.new do
        # @return [Address]
        attribute(:address, Address)

        # @return [String]
        attribute(:alias, String)

        # @return [String]
        attribute(:supply_source_code, String, from: "supplySourceCode")
      end
    end
  end
end
