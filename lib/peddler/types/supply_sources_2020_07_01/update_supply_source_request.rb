# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/supply_source_configuration"
require "peddler/types/supply_sources_2020_07_01/supply_source_capabilities"

module Peddler
  module Types
    module SupplySources20200701
      # A request to update the configuration and capabilities of a supply source.
      UpdateSupplySourceRequest = Structure.new do
        # @return [String]
        attribute(:alias, String)

        # @return [SupplySourceConfiguration]
        attribute(:configuration, SupplySourceConfiguration)

        # @return [SupplySourceCapabilities]
        attribute(:capabilities, SupplySourceCapabilities)
      end
    end
  end
end
