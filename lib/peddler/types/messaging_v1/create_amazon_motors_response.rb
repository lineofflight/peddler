# frozen_string_literal: true

require "peddler/types/messaging_v1/error"

module Peddler
  module Types
    module MessagingV1
      # The response schema for the createAmazonMotors operation.
      CreateAmazonMotorsResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
