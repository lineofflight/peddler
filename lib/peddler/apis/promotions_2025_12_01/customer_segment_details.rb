# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Additional segment type-specific details. Use the appropriate property based on `segmentType`.
      CustomerSegmentDetails = Structure.new do
        # @return [BrandSegmentDetails] Brand segment details. This field is required when `segmentType` is `BRAND`.
        attribute?(:brand_segment_details, BrandSegmentDetails, from: "brandSegmentDetails")
      end
    end
  end
end
