# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MessagingV1
      # The response schema for the `getMessagingActionsForOrder` operation.
      GetMessagingActionsForOrderResponse = Structure.new do
        # The messaging actions response that is associated with the specified `amazonOrderId`.
        attribute?(:_embedded, Hash)

        # The links response that is associated with the specified `amazonOrderId`.
        attribute?(:_links, Hash)

        attribute?(:errors, [Error])
      end
    end
  end
end
