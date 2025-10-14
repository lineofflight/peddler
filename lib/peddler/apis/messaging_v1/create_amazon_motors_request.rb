# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MessagingV1
      # The request schema for the createAmazonMotors operation.
      CreateAmazonMotorsRequest = Structure.new do
        # @return [Array<Attachment>] Attachments to include in the message to the buyer. If any text is included in the
        # attachment, the text must be written in the buyer's language of preference, which can be retrieved from the
        # GetAttributes operation.
        attribute?(:attachments, [Attachment])
      end
    end
  end
end
