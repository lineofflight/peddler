# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Response returned when the schedule transfer's delete request is successful.
      DeleteTransferSchedule = Structure.new do
        # @return [String] A success code that specifies the delete operation was successful. eg:HTTP 200.
        attribute(:code, String)

        # @return [String] A message that describes the success condition of the delete schedule transaction.
        attribute(:message, String)

        # @return [String] Additional details that can help the caller understand the operation execution.
        attribute(:details, String)
      end
    end
  end
end
