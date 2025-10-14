# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MessagingV1
      # The response schema for the `getMessagingActionsForOrder` operation.
      GetMessagingActionsForOrderResponse = Structure.new do
        # @return [Hash] The messaging actions response that is associated with the specified `amazonOrderId`.
        attribute?(:_embedded, Hash)

        # @return [Hash] The links response that is associated with the specified `amazonOrderId`.
        attribute?(:_links, Hash)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
