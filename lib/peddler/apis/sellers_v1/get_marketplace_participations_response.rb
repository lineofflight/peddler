# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      # The response schema for the `getMarketplaceParticipations` operation.
      GetMarketplaceParticipationsResponse = Structure.new do
        # The errors encountered by the `getMarketplaceParticipations` operation.
        attribute?(:errors, [Error])

        # The payload for the `getMarketplaceParticipations` operation.
        attribute?(:payload, [MarketplaceParticipation])
      end
    end
  end
end
