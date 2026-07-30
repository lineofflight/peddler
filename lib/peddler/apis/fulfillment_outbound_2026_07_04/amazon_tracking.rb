# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Amazon tracking information for a package.
      AmazonTracking = Structure.new do
        # @return [String] The amazon tracking number that can be used to obtain tracking and delivery information.
        attribute?(:tracking_number, String, from: "trackingNumber")

        # @return [String] Represents the tracking URL where amazon tracking information is shown.
        attribute?(:tracking_url, String, from: "trackingUrl")
      end
    end
  end
end
