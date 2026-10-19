# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Substitution preferences for an order item.
      SubstitutionPreferences = Structure.new do
        # The type of substitution that these preferences represent. Known values: `CUSTOMER_PREFERENCE`,
        # `AMAZON_RECOMMENDED`, `DO_NOT_SUBSTITUTE`.
        attribute(:substitution_type, String, null: false, from: "SubstitutionType")

        # Substitution options for the order item.
        attribute?(:substitution_options, [SubstitutionOption], from: "SubstitutionOptions")
      end
    end
  end
end
