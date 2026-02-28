# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Describes the segment in which the offer is featured.
      FeaturedOfferSegment = Structure.new do
        # @return [String] The customer membership type that makes up this segment
        attribute(:customer_membership, String, null: false, from: "customerMembership")

        # @return [SegmentDetails] The details about the segment.
        attribute(:segment_details, SegmentDetails, null: false, from: "segmentDetails")
      end
    end
  end
end
