# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The supply source details, including configurations and capabilities.
      SupplySource = Structure.new do
        # @return [Address]
        attribute?(:address, Address)

        # @return [String]
        attribute?(:alias, String)

        # @return [SupplySourceCapabilities]
        attribute?(:capabilities, SupplySourceCapabilities)

        # @return [SupplySourceConfiguration]
        attribute?(:configuration, SupplySourceConfiguration)

        # @return [String]
        attribute?(:created_at, String, from: "createdAt")

        # @return [String]
        attribute?(:status, String)

        # @return [String]
        attribute?(:supply_source_code, String, from: "supplySourceCode")

        # @return [String]
        attribute?(:supply_source_id, String, from: "supplySourceId")

        # @return [String]
        attribute?(:updated_at, String, from: "updatedAt")
      end
    end
  end
end
