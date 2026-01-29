# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Preferences that can be passed in context of a replenishment order
      ReplenishmentPreferences = Structure.new do
        # @return [String] Confirmation Mode to use for the created Replenishment order.
        attribute?(:confirmation, String)
      end
    end
  end
end
