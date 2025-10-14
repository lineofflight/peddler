# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MessagingV1
      # The response schema for the createConfirmOrderDetails operation.
      CreateConfirmOrderDetailsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
