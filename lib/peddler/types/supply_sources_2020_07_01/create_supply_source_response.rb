# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The result of creating a new supply source.
      CreateSupplySourceResponse = Structure.new do
        # @return [String]
        attribute(:supply_source_id, String, from: "supplySourceId")

        # @return [String]
        attribute(:supply_source_code, String, from: "supplySourceCode")
      end
    end
  end
end
