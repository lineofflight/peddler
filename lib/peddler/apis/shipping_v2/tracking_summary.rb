# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A package status summary.
      TrackingSummary = Structure.new do
        # @return [String]
        attribute?(:status, String)

        # @return [TrackingDetailCodes]
        attribute?(:tracking_detail_codes, TrackingDetailCodes, from: "trackingDetailCodes")
      end
    end
  end
end
