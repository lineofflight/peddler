# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/operational_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # The services capability of a supply source.
      ServicesCapability = Structure.new do
        # @return [:boolean] When true, `SupplySource` supports the Service capability.
        attribute?(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration]
        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")
      end
    end
  end
end
