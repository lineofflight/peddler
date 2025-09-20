# frozen_string_literal: true

require "peddler/types/sellers_v1/marketplace_participation"

module Peddler
  module Types
    module SellersV1
      # List of marketplace participations.
      class MarketplaceParticipationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| MarketplaceParticipation.parse(item) })
          end
        end
      end
    end
  end
end
