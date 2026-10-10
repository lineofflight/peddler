# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellerWallet20240301
      # The contact information of the payee. This field is required when the request `bankAccountOwnershipType` is
      # `THIRD_PARTY`. The contact information is used for payee verification and registration purposes.
      PayeeContactInformation = Structure.new do
        # Address Line 1 of the public address.
        attribute(:address_line1, String, null: false, from: "addressLine1")

        # City name of the public address.
        attribute(:city, String, null: false)

        # The two digit country code, in ISO 3166 format.
        attribute(:country_code, String, null: false, from: "countryCode")

        # Email address of the payee.
        attribute(:email_address, String, null: false, from: "emailAddress")

        # Type of entity of the payee.
        attribute(:payee_entity_type, String, null: false, from: "payeeEntityType")

        # First name of the payee. There is a 50 character limit.
        attribute(:payee_first_name, String, null: false, from: "payeeFirstName")

        # Last name of the payee. There is a 50 character limit.
        attribute(:payee_last_name, String, null: false, from: "payeeLastName")

        # Valid phone number of the payee.
        attribute(:phone_number, String, null: false, from: "phoneNumber")

        # Postal code of the public address.
        attribute(:postal_code, String, null: false, from: "postalCode")

        # State name of the public address. This is the state or region for China-based addresses.
        attribute(:state, String, null: false)

        # Address Line 2 of the public address.
        attribute?(:address_line2, String, from: "addressLine2")

        # Country name of the public address.
        attribute?(:country, String)

        # Middle name of the payee. There is a 50 character limit.
        attribute?(:payee_middle_name, String, from: "payeeMiddleName")
      end
    end
  end
end
