# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
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
