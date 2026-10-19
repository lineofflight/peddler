# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The supply source details, including configurations and capabilities.
      SupplySource = Structure.new do
        attribute?(:address, Address)

        attribute?(:alias, String)

        attribute?(:capabilities, SupplySourceCapabilities)

        attribute?(:configuration, SupplySourceConfiguration)

        attribute?(:created_at, String, from: "createdAt")

        # Known values: `Active`, `Inactive`, `Archived`.
        attribute?(:status, String)

        attribute?(:supply_source_code, String, from: "supplySourceCode")

        attribute?(:supply_source_id, String, from: "supplySourceId")

        attribute?(:updated_at, String, from: "updatedAt")
      end
    end
  end
end
