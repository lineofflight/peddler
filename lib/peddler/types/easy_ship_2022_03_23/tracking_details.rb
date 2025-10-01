# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module EasyShip20220323
      # Representation of tracking metadata.
      TrackingDetails = Structure.new do
        # @return [String] The tracking identifier for the scheduled package.
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
