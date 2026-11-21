# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The seller's contact information.
      ContactInformation = Structure.new do
        # The contact's name.
        attribute(:name, String, null: false)

        # The phone number.
        attribute(:phone_number, String, null: false, from: "phoneNumber")

        # The email address.
        attribute?(:email, String)
      end
    end
  end
end
