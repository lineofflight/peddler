# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentTransactions20211228
      # Error response returned when the request is unsuccessful.
      Error = Structure.new do
        # @return [String] An error code that identifies the type of error that occurred.
        attribute(:code, String)

        # @return [String] A message that describes the error condition.
        attribute(:message, String)

        # @return [String] Additional details that can help the caller understand or fix the issue.
        attribute(:details, String)
      end
    end
  end
end
