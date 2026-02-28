# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains a start and end DateTime representing a time range.
      Window = Structure.new do
        # @return [Time] The end timestamp of the window.
        attribute(:end, Time, null: false)

        # @return [Time] The start timestamp of the window.
        attribute(:start, Time, null: false)

        # @return [Time] The timestamp at which this Window can no longer be edited.
        attribute?(:editable_until, Time, from: "editableUntil")
      end
    end
  end
end
