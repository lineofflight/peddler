# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Additional details specific to the `BRAND` segments type.
      BrandSegmentDetails = Structure.new do
        # @return [String] Brand identifier.
        attribute(:brand_id, String, null: false, from: "brandId")
      end
    end
  end
end
