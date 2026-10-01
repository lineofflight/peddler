# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # The content of an email contact.
      EmailContent = Structure.new do
        # @return [String] The email body of the contact.
        attribute(:message, String, null: false)

        # @return [Participant] The entity who sent the contact.
        attribute(:sender, Participant, null: false)

        # @return [Array<Attachment>] All attachments included in the contact.
        attribute?(:attachments, [Attachment])
      end
    end
  end
end
