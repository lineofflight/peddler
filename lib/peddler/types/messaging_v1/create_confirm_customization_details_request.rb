# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/messaging_v1/attachment"

module Peddler
  module Types
    module MessagingV1
      # The request schema for the confirmCustomizationDetails operation.
      CreateConfirmCustomizationDetailsRequest = Structure.new do
        # @return [String] The text to be sent to the buyer. Only links related to customization details are allowed. Do
        # not include HTML or email addresses. The text must be written in the buyer's language of preference, which can
        # be retrieved from the GetAttributes operation.
        attribute(:text, String)

        # @return [Array<Attachment>] Attachments to include in the message to the buyer.
        attribute(:attachments, [Attachment])
      end
    end
  end
end
