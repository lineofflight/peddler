# frozen_string_literal: true

require "peddler/types/sellers_v1/marketplace_participation"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module SellersV1
      # List of marketplace participations.
      class MarketplaceParticipationList < Array
        class << self
          def parse(array)
            new(array.map { |item| MarketplaceParticipation.parse(item) })
          end
        end
      end
    end
  end
end
