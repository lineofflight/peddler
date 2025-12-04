# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # The contact information of the payee. This field is required when the request `bankAccountOwnershipType` is
      # `THIRD_PARTY`. The contact information is used for payee verification and registration purposes.
      PayeeContactInformation = Structure.new do
        # @return [String] Address Line 1 of the public address
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] City name of the public address
        attribute(:city, String)

        # @return [String] The two digit country code, in ISO 3166 format.
        attribute(:country_code, String, from: "countryCode")

        # @return [String] Email address of the payee.
        attribute(:email_address, String, from: "emailAddress")

        # @return [String] Type of entity of the payee.
        attribute(:payee_entity_type, String, from: "payeeEntityType")

        # @return [String] First name of the payee. There is a 50 character limit.
        attribute(:payee_first_name, String, from: "payeeFirstName")

        # @return [String] Last name of the payee. There is a 50 character limit.
        attribute(:payee_last_name, String, from: "payeeLastName")

        # @return [String] Valid phone number of the payee.
        attribute(:phone_number, String, from: "phoneNumber")

        # @return [String] Postal code of the public address
        attribute(:postal_code, String, from: "postalCode")

        # @return [String] State name of the public address. This is the state or region for China-based addresses.
        attribute(:state, String)

        # @return [String] Address Line 2 of the public address
        attribute?(:address_line2, String, from: "addressLine2")

        # @return [String] Country name of the public address
        attribute?(:country, String)

        # @return [String] Middle name of the payee. There is a 50 character limit.
        attribute?(:payee_middle_name, String, from: "payeeMiddleName")
      end
    end
  end
end
