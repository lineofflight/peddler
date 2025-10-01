# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/supply_sources_2020_07_01/supply_source_capabilities"
require "peddler/types/supply_sources_2020_07_01/supply_source_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # A request to update the configuration and capabilities of a supply source.
      UpdateSupplySourceRequest = Structure.new do
        # @return [String]
        attribute?(:alias, String)

        # @return [SupplySourceCapabilities]
        attribute?(:capabilities, SupplySourceCapabilities)

        # @return [SupplySourceConfiguration]
        attribute?(:configuration, SupplySourceConfiguration)
      end
    end
  end
end
