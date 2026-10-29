# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Messaging20260420
      # The details of the automated action.
      AutomationDetails = Structure.new do
        # @return [String] The auto-response message text sent to the buyer. Required for `AUTO_RESPONSE` automation
        #   configurations.
        attribute(:auto_response_text, String, null: false, from: "autoResponseText")

        # @return [String] A URL to an attachment included with the auto-response message.
        attribute?(:auto_response_attachment_url, String, from: "autoResponseAttachmentUrl")
      end
    end
  end
end
