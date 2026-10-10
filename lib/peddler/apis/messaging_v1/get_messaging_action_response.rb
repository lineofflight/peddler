# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MessagingV1
      # Describes a messaging action that can be taken for an order. Provides a JSON Hypertext Application Language
      # (HAL) link to the JSON schema document that describes the expected input.
      GetMessagingActionResponse = Structure.new do
        # The embedded response associated with the messaging action.
        attribute?(:_embedded, Hash)

        # The links response that is associated with the messaging action.
        attribute?(:_links, Hash)

        attribute?(:errors, [Error])

        attribute?(:payload, MessagingAction)
      end
    end
  end
end
