# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Information pertaining to the preparation of inbound products.
      PrepInstruction = Structure.new do
        # Known values: `AMAZON`, `SELF`.
        attribute?(:prep_owner, String, from: "prepOwner")

        # The type of preparation to be done. For more information about preparing items, refer to [Prep
        # guidance](https://sellercentral.amazon.com/help/hub/reference/external/GF4G7547KSLDX2KC) on Seller Central.
        attribute?(:prep_type, String, from: "prepType")
      end
    end
  end
end
