# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/messaging_v1/error"
require "peddler/types/messaging_v1/messaging_action"

module Peddler
  module Types
    module MessagingV1
      # Describes a messaging action that can be taken for an order. Provides a JSON Hypertext Application Language
      # (HAL) link to the JSON schema document that describes the expected input.
      GetMessagingActionResponse = Structure.new do
        # @return [Hash] The embedded response associated with the messaging action.
        attribute?(:_embedded, Hash)

        # @return [Hash] The links response that is associated with the messaging action.
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [MessagingAction]
        attribute?(:payload, MessagingAction)
      end
    end
  end
end
