# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The details about the segment. The FeaturedOfferExpectedPrice API uses only the sampleLocation portion as input.
      SegmentDetails = Structure.new do
        # @return [Float] The glance view weighted percentage for this segment, which is the glance views for this
        # segment as a percentage of total glance views across all segments for the ASIN. A higher percentage indicates
        # that more Amazon customers receive this offer as the Featured Offer.
        attribute?(:glance_view_weight_percentage, Float, from: "glanceViewWeightPercentage")

        # @return [SampleLocation] The representative location that features the offer for the segment.
        attribute?(:sample_location, SampleLocation, from: "sampleLocation")
      end
    end
  end
end
