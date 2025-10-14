# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class MessagingV1
      # The request schema for the createWarranty operation.
      CreateWarrantyRequest = Structure.new do
        # @return [Array<Attachment>] Attachments to include in the message to the buyer. If any text is included in the
        # attachment, the text must be written in the buyer's language of preference, which can be retrieved from the
        # GetAttributes operation.
        attribute?(:attachments, [Attachment])

        # @return [Time] The end date of the warranty coverage to include in the message to the buyer.
        attribute?(:coverage_end_date, Time, from: "coverageEndDate")

        # @return [Time] The start date of the warranty coverage to include in the message to the buyer.
        attribute?(:coverage_start_date, Time, from: "coverageStartDate")
      end
    end
  end
end
