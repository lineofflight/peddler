# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The capabilities of a supply source.
      SupplySourceCapabilities = Structure.new do
        # @return [OutboundCapability]
        attribute?(:outbound, OutboundCapability)

        # @return [ServicesCapability]
        attribute?(:services, ServicesCapability)
      end
    end
  end
end
