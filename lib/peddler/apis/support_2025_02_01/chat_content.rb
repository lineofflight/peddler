# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Support20250201
      # The content for a chat contact.
      ChatContent = Structure.new do
        # A list of events that make up the chat contact. Not all chat contacts are broken into chat events, and it is
        # recommended to fallback on the `transcript` when `events` is empty.
        attribute(:events, [ChatEvent], null: false)

        # The human-readable transcript of the chat contact.
        attribute(:transcript, String, null: false)
      end
    end
  end
end
