# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/address"
require "peddler/types/supply_sources_2020_07_01/supply_source_configuration"
require "peddler/types/supply_sources_2020_07_01/supply_source_capabilities"

module Peddler
  module Types
    module SupplySources20200701
      # The supply source details, including configurations and capabilities.
      SupplySource = Structure.new do
        # @return [String]
        attribute?(:supply_source_id, String, from: "supplySourceId")

        # @return [String]
        attribute?(:supply_source_code, String, from: "supplySourceCode")

        # @return [String]
        attribute?(:alias, String)

        # @return [String]
        attribute?(:status, String)

        # @return [Address]
        attribute?(:address, Address)

        # @return [SupplySourceConfiguration]
        attribute?(:configuration, SupplySourceConfiguration)

        # @return [SupplySourceCapabilities]
        attribute?(:capabilities, SupplySourceCapabilities)

        # @return [String]
        attribute?(:created_at, String, from: "createdAt")

        # @return [String]
        attribute?(:updated_at, String, from: "updatedAt")
      end
    end
  end
end
