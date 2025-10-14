# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
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
