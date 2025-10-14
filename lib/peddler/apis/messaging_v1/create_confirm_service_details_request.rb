# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MessagingV1
      # The request schema for the createConfirmServiceDetails operation.
      CreateConfirmServiceDetailsRequest = Structure.new do
        # @return [String] The text to be sent to the buyer. Only links related to Home Service calls are allowed. Do
        # not include HTML or email addresses. The text must be written in the buyer's language of preference, which can
        # be retrieved from the GetAttributes operation.
        attribute?(:text, String)
      end
    end
  end
end
