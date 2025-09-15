# frozen_string_literal: true

require "peddler/types/messaging_v1/attachment"

module Peddler
  module Types
    module MessagingV1
      # The request schema for the `sendInvoice` operation.
      InvoiceRequest = Structure.new do
        # @return [Array<Attachment>] Attachments to include in the message to the buyer.
        attribute(:attachments, [Attachment])
      end
    end
  end
end
