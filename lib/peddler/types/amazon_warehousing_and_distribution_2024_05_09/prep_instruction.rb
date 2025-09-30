# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Information pertaining to the preparation of inbound products.
      PrepInstruction = Structure.new do
        # @return [String]
        attribute?(:prep_owner, String, from: "prepOwner")

        # @return [String] The type of preparation to be done. For more information about preparing items, refer to
        # [Prep guidance](https://sellercentral.amazon.com/help/hub/reference/external/GF4G7547KSLDX2KC) on Seller
        # Central.
        attribute?(:prep_type, String, from: "prepType")
      end
    end
  end
end
