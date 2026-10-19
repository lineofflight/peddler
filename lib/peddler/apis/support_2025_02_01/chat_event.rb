# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Support20250201
      # A single event from a chat contact.
      ChatEvent = Structure.new do
        # The time at which the event occurred.
        attribute(:timestamp, Time, null: false)

        # The type of chat event. Known values: `MESSAGE`, `ATTACHMENT`, `PARTICIPANT_JOINED`, `PARTICIPANT_LEFT`,
        # `PARTICIPANT_IDLE`, `CHAT_ENDED`.
        attribute(:type, String, null: false)

        # All attachments included in the event. Only present if the event type is `ATTACHMENT`.
        attribute?(:attachments, [Attachment])

        # The message from the chat event. Only present if the event type is `MESSAGE`.
        attribute?(:message, String)

        # The entity that is associated with the event.
        attribute?(:participant, Participant)
      end
    end
  end
end
