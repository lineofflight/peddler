# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MessagingV1
      # The request schema for the `createDigitalAccessKey` operation.
      CreateDigitalAccessKeyRequest = Structure.new do
        # Attachments that you want to include in the message to the buyer.
        attribute?(:attachments, [Attachment])

        # The text that is sent to the buyer. Only links that are related to the digital access key are allowed. Do not
        # include HTML or email addresses. The text must be written in the buyer's preferred language, which you can
        # retrieve from the `GetAttributes` operation.
        attribute?(:text, String)
      end
    end
  end
end
