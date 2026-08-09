# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # The location where a tracking milestone occurred.
      TrackingMilestoneLocation = Structure.new do
        # @return [TrackingMilestoneAddress] The physical address where the milestone occurred.
        attribute?(:address, TrackingMilestoneAddress)
      end
    end
  end
end
