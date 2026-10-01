# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Support20250201
      # A single event from a chat contact.
      ChatEvent = Structure.new do
        # @return [Time] The time at which the event occurred.
        attribute(:timestamp, Time, null: false)

        # @return [String] The type of chat event.
        attribute(:type, String, null: false)

        # @return [Array<Attachment>] All attachments included in the event. Only present if the event type is
        #   `ATTACHMENT`.
        attribute?(:attachments, [Attachment])

        # @return [String] The message from the chat event. Only present if the event type is `MESSAGE`.
        attribute?(:message, String)

        # @return [Participant] The entity that is associated with the event.
        attribute?(:participant, Participant)
      end
    end
  end
end
