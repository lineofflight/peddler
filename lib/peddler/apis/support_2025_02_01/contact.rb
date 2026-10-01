# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Support20250201
      # A contact.
      Contact = Structure.new do
        # @return [String] The contact channel for communication between the selling partner and Amazon.
        attribute(:channel, String, null: false)

        # @return [String] A unique identifier for the contact
        attribute(:contact_id, String, null: false, from: "contactId")

        # @return [Time] The time at which the contact was created. In [ISO
        #   8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute(:created_date, Time, null: false, from: "createdDate")

        # @return [ChatContent] The content of the contact. Only available if the contact channel is `CHAT`.
        attribute?(:chat_content, ChatContent, from: "chatContent")

        # @return [EmailContent] The content of the contact. Only available if the contact channel is `EMAIL`.
        attribute?(:email_content, EmailContent, from: "emailContent")

        # @return [PhoneContent] The content of the contact. Only available if the contact channel is `PHONE`.
        attribute?(:phone_content, PhoneContent, from: "phoneContent")
      end
    end
  end
end
