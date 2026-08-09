# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # The status codes and description of the milestone event.
      TrackingMilestoneStatus = Structure.new do
        # @return [String] A status code that identifies the milestone event (for example, `DELIVERED`,
        #   `CUSTOMS_CLEARED`, `DEPARTED`).
        attribute(:code, String, null: false)

        # @return [String] A human-readable explanation of the milestone event.
        attribute(:description, String, null: false)

        # @return [String] Status subcode that provides additional details about the milestone status. Valid values vary
        #   by milestone (for example, a `DELIVERED` milestone might include a `subCode` for the delivery location).
        attribute?(:sub_code, String, from: "subCode")
      end
    end
  end
end
