# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module MessagingV1
      # The request schema for the createWarranty operation.
      CreateWarrantyRequest = Structure.new do
        # Attachments to include in the message to the buyer. If any text is included in the attachment, the text must
        # be written in the buyer's language of preference, which can be retrieved from the GetAttributes operation.
        attribute?(:attachments, [Attachment])

        # The end date of the warranty coverage to include in the message to the buyer.
        attribute?(:coverage_end_date, Time, from: "coverageEndDate")

        # The start date of the warranty coverage to include in the message to the buyer.
        attribute?(:coverage_start_date, Time, from: "coverageStartDate")
      end
    end
  end
end
