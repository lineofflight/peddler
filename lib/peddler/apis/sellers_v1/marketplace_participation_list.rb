# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class SellersV1
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
