# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MessagingV1
      # The request schema for the `sendInvoice` operation.
      InvoiceRequest = Structure.new do
        # @return [Array<Attachment>] Attachments to include in the message to the buyer.
        attribute?(:attachments, [Attachment])
      end
    end
  end
end
