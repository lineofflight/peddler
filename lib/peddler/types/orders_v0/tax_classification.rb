# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # The tax classification of the order.
      TaxClassification = Structure.new do
        # @return [String] The type of tax.
        attribute?(:name, String, from: "Name")

        # @return [String] The buyer's tax identifier.
        attribute?(:value, String, from: "Value")
      end
    end
  end
end
