# frozen_string_literal: true

require "peddler/types/messaging_v1/attachment"

module Peddler
  module Types
    module MessagingV1
      # The request schema for the createWarranty operation.
      CreateWarrantyRequest = Structure.new do
        # @return [Array<Attachment>] Attachments to include in the message to the buyer. If any text is included in the
        # attachment, the text must be written in the buyer's language of preference, which can be retrieved from the
        # GetAttributes operation.
        attribute(:attachments, [Attachment])

        # @return [String] The start date of the warranty coverage to include in the message to the buyer.
        attribute(:coverage_start_date, String, from: "coverageStartDate")

        # @return [String] The end date of the warranty coverage to include in the message to the buyer.
        attribute(:coverage_end_date, String, from: "coverageEndDate")
      end
    end
  end
end
