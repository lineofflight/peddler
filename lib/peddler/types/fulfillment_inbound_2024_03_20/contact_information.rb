# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The seller's contact information.
      ContactInformation = Structure.new do
        # @return [String] The contact's name.
        attribute(:name, String)

        # @return [String] The phone number.
        attribute(:phone_number, String, from: "phoneNumber")

        # @return [String] The email address.
        attribute?(:email, String)
      end
    end
  end
end
