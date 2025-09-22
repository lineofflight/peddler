# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/outbound_capability"
require "peddler/types/supply_sources_2020_07_01/services_capability"

module Peddler
  module Types
    module SupplySources20200701
      # The capabilities of a supply source.
      SupplySourceCapabilities = Structure.new do
        # @return [OutboundCapability]
        attribute(:outbound, OutboundCapability)

        # @return [ServicesCapability]
        attribute(:services, ServicesCapability)
      end
    end
  end
end
