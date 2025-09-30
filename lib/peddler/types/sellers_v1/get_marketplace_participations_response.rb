# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/sellers_v1/marketplace_participation"
require "peddler/types/sellers_v1/error"

module Peddler
  module Types
    module SellersV1
      # The response schema for the `getMarketplaceParticipations` operation.
      GetMarketplaceParticipationsResponse = Structure.new do
        # @return [Array<MarketplaceParticipation>] The payload for the `getMarketplaceParticipations` operation.
        attribute?(:payload, [MarketplaceParticipation])

        # @return [Array<Error>] The errors encountered by the `getMarketplaceParticipations` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
