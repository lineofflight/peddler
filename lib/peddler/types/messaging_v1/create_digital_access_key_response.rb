# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/messaging_v1/error"

module Peddler
  module Types
    module MessagingV1
      # The response schema for the `createDigitalAccessKey` operation.
      CreateDigitalAccessKeyResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
