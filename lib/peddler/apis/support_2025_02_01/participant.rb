# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # A participant for a single-directional communication between a selling partner and Amazon support.
      Participant = Structure.new do
        # @return [String] The human-readable name of the participant.
        attribute(:display_name, String, null: false, from: "displayName")

        # @return [String] The role of the participant.
        attribute(:role, String, null: false)
      end
    end
  end
end
