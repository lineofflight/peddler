# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Support20250201
      # A contact.
      Contact = Structure.new do
        # The contact channel for communication between the selling partner and Amazon.
        attribute(:channel, String, null: false)

        # A unique identifier for the contact
        attribute(:contact_id, String, null: false, from: "contactId")

        # The time at which the contact was created. In [ISO 8601](https://developer-docs.amazon/sp-api/docs/iso-8601)
        # format.
        attribute(:created_date, Time, null: false, from: "createdDate")

        # The content of the contact. Only available if the contact channel is `CHAT`.
        attribute?(:chat_content, ChatContent, from: "chatContent")

        # The content of the contact. Only available if the contact channel is `EMAIL`.
        attribute?(:email_content, EmailContent, from: "emailContent")

        # The content of the contact. Only available if the contact channel is `PHONE`.
        attribute?(:phone_content, PhoneContent, from: "phoneContent")
      end
    end
  end
end
