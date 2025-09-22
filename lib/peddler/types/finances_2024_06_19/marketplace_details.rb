# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Information about the marketplace where the transaction occurred.
      MarketplaceDetails = Structure.new do
        # @return [String] The identifier of the marketplace where the transaction occurred. The marketplace ID is the
        # globally unique identifier of a marketplace. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The name of the marketplace where the transaction occurred.
        #
        # Example: 'Amazon.com','Amazon.in'
        attribute(:marketplace_name, String, from: "marketplaceName")
      end
    end
  end
end
