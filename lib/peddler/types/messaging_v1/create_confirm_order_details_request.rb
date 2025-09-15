# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MessagingV1
      # The request schema for the createConfirmOrderDetails operation.
      CreateConfirmOrderDetailsRequest = Structure.new do
        # @return [String] The text to be sent to the buyer. Only links related to order completion are allowed. Do not
        # include HTML or email addresses. The text must be written in the buyer's language of preference, which can be
        # retrieved from the GetAttributes operation.
        attribute(:text, String)
      end
    end
  end
end
