# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShipmentInvoicingV0
      # The tax classification for the entity.
      TaxClassification = Structure.new do
        # The type of tax.
        attribute?(:name, String, from: "Name")

        # The entity's tax identifier.
        attribute?(:value, String, from: "Value")
      end
    end
  end
end
