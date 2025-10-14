# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Input segment for featured offer expected price. The segment contains the location information for which
      # featured offer expected price is requested.
      Segment = Structure.new do
        # @return [SegmentDetails] Segment details
        attribute?(:segment_details, SegmentDetails, from: "segmentDetails")
      end
    end
  end
end
