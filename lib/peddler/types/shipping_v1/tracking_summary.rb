# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The tracking summary.
      TrackingSummary = Structure.new do
        # @return [String] The derived status based on the events in the eventHistory.
        attribute?(:status, String)
      end
    end
  end
end
