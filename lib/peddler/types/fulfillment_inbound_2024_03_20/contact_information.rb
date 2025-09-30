# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The seller's contact information.
      ContactInformation = Structure.new do
        # @return [String] The email address.
        attribute?(:email, String)

        # @return [String] The contact's name.
        attribute(:name, String)

        # @return [String] The phone number.
        attribute(:phone_number, String, from: "phoneNumber")
      end
    end
  end
end
