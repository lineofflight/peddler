# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      MarketplaceParticipation = Structure.new do
        attribute(:marketplace, Marketplace, null: false)

        attribute(:participation, Participation, null: false)

        # The name of the seller's store as displayed in the marketplace.
        attribute(:store_name, String, null: false, from: "storeName")
      end
    end
  end
end
