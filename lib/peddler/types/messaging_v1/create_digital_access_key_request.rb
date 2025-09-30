# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/messaging_v1/attachment"

module Peddler
  module Types
    module MessagingV1
      # The request schema for the `createDigitalAccessKey` operation.
      CreateDigitalAccessKeyRequest = Structure.new do
        # @return [String] The text that is sent to the buyer. Only links that are related to the digital access key are
        # allowed. Do not include HTML or email addresses. The text must be written in the buyer's preferred language,
        # which you can retrieve from the `GetAttributes` operation.
        attribute?(:text, String)

        # @return [Array<Attachment>] Attachments that you want to include in the message to the buyer.
        attribute?(:attachments, [Attachment])
      end
    end
  end
end
