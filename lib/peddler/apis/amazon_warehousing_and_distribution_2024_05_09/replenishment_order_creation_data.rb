# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # This structure represents the payload for creating an AFN Replenishment Order.
      # By default, all replenishment orders created support Partial order preferences.
      ReplenishmentOrderCreationData = Structure.new do
        # @return [ReplenishmentPreferences]
        attribute?(:preferences, ReplenishmentPreferences)

        # @return [Array<DistributionProduct>] Requested amount of single product units to be replenished.
        attribute?(:products, [DistributionProduct])
      end
    end
  end
end
