# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The result of creating a new supply source.
      CreateSupplySourceResponse = Structure.new do
        attribute(:supply_source_code, String, null: false, from: "supplySourceCode")

        attribute(:supply_source_id, String, null: false, from: "supplySourceId")
      end
    end
  end
end
