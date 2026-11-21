# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # A similar item for the specified ASIN `marketplaceId` combination.
      Item = Structure.new do
        # The Amazon identifier for the item.
        attribute(:asin, String, null: false)
      end
    end
  end
end
