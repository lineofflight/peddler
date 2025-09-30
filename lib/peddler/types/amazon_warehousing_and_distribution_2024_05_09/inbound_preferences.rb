# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Preferences that can be passed in context of an inbound order
      InboundPreferences = Structure.new do
        # @return [String] Pass a preferred region so that the inbound order can be shipped to an AWD warehouse located
        # in that region. This doesn't guarantee the order to be assigned in the specified destination region as it
        # depends on warehouse capacity availability. AWD currently supports following region IDs: [us-west, us-east,
        # us-southcentral, us-southeast]
        attribute?(:destination_region, String, from: "destinationRegion")
      end
    end
  end
end
