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
            array.is_a?(Array) ? new(array.map { |item| MarketplaceParticipation.parse(item) }) : new
          end
        end
      end
    end
  end
end
