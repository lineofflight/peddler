# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # The physical address of the location.
      TrackingMilestoneAddress = Structure.new do
        # @return [String] The city where the milestone occurred.
        attribute?(:city, String)

        # @return [String] The two-character country code in ISO 3166-1 alpha-2 format (for example, `US`).
        attribute?(:country_code, String, from: "countryCode")

        # @return [String] The state or region where the milestone occurred.
        attribute?(:region, String)
      end
    end
  end
end
