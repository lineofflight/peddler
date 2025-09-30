# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/substitution_option"

module Peddler
  module Types
    module OrdersV0
      # Substitution preferences for an order item.
      SubstitutionPreferences = Structure.new do
        # @return [String] The type of substitution that these preferences represent.
        attribute(:substitution_type, String, from: "SubstitutionType")

        # @return [Array<SubstitutionOption>] Substitution options for the order item.
        attribute?(:substitution_options, [SubstitutionOption], from: "SubstitutionOptions")
      end
    end
  end
end
