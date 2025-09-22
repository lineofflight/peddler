# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/segment_details"

module Peddler
  module Types
    module ProductPricing20220501
      # Input segment for featured offer expected price. The segment contains the location information for which
      # featured offer expected price is requested.
      Segment = Structure.new do
        # @return [SegmentDetails] Segment details
        attribute(:segment_details, SegmentDetails, from: "segmentDetails")
      end
    end
  end
end
