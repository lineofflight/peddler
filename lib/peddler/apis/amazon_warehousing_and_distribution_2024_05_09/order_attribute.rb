# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Consists of the order preference and corresponding preference value.
      OrderAttribute = Structure.new do
        # @return [String] Preference for the distribution order.
        attribute(:order_preference, String, null: false, from: "orderPreference")

        # @return [String] Value for the order preference.
        attribute(:order_preference_value, String, null: false, from: "orderPreferenceValue")
      end
    end
  end
end
