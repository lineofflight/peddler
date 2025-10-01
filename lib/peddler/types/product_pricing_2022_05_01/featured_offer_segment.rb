# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_2022_05_01/segment_details"

module Peddler
  module Types
    module ProductPricing20220501
      # Describes the segment in which the offer is featured.
      FeaturedOfferSegment = Structure.new do
        # @return [String] The customer membership type that makes up this segment
        attribute(:customer_membership, String, from: "customerMembership")

        # @return [SegmentDetails] The details about the segment.
        attribute(:segment_details, SegmentDetails, from: "segmentDetails")
      end
    end
  end
end
