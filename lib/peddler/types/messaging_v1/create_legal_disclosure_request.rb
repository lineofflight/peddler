# frozen_string_literal: true

require "peddler/types/messaging_v1/attachment"

module Peddler
  module Types
    module MessagingV1
      # The request schema for the createLegalDisclosure operation.
      CreateLegalDisclosureRequest = Structure.new do
        # @return [Array<Attachment>] Attachments to include in the message to the buyer. If any text is included in the
        # attachment, the text must be written in the buyer's language of preference, which can be retrieved from the
        # GetAttributes operation.
        attribute(:attachments, [Attachment])
      end
    end
  end
end
