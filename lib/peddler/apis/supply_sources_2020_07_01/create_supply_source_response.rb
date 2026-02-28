# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The result of creating a new supply source.
      CreateSupplySourceResponse = Structure.new do
        # @return [String]
        attribute(:supply_source_code, String, null: false, from: "supplySourceCode")

        # @return [String]
        attribute(:supply_source_id, String, null: false, from: "supplySourceId")
      end
    end
  end
end
