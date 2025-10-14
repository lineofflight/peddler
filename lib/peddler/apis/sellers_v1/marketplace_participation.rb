# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellersV1
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
