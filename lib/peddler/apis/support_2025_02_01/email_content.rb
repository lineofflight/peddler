# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Support20250201
      # The content of an email contact.
      EmailContent = Structure.new do
        # The email body of the contact.
        attribute(:message, String, null: false)

        # The entity who sent the contact.
        attribute(:sender, Participant, null: false)

        # All attachments included in the contact.
        attribute?(:attachments, [Attachment])
      end
    end
  end
end
