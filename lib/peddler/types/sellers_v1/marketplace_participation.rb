# frozen_string_literal: true

require "peddler/types/sellers_v1/marketplace"
require "peddler/types/sellers_v1/participation"

module Peddler
  module Types
    module SellersV1
      MarketplaceParticipation = Structure.new do
        # @return [Marketplace]
        attribute(:marketplace, Marketplace)

        # @return [Participation]
        attribute(:participation, Participation)

        # @return [String] The name of the seller's store as displayed in the marketplace.
        attribute(:store_name, String, from: "storeName")
      end
    end
  end
end
