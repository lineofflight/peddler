# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains a start and end DateTime representing a time range.
      Window = Structure.new do
        # @return [String] The end timestamp of the window.
        attribute(:end, String)

        # @return [String] The start timestamp of the window.
        attribute(:start, String)

        # @return [String] The timestamp at which this Window can no longer be edited.
        attribute?(:editable_until, String, from: "editableUntil")
      end
    end
  end
end
