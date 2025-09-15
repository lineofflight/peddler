# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Address for bank account verification of the Payee. For example, this can be a person or business mailing
      # address
      AccountHolderAddress = Structure.new do
        # @return [String] Address Line 1 of the public address
        attribute(:address_line1, String, from: "addressLine1")

        # @return [String] Address Line 2 of the public address
        attribute(:address_line2, String, from: "addressLine2")

        # @return [String] City name of the public address
        attribute(:city, String)

        # @return [String] State name of the public address. This is the state or region for China-based addresses.
        attribute(:state, String)

        # @return [String] Postal code of the public address
        attribute(:postal_code, String, from: "postalCode")

        # @return [String] Country name of the public address
        attribute(:country, String)

        # @return [String] The two digit country code, in ISO 3166 format.
        attribute(:country_code, String, from: "countryCode")
      end
    end
  end
end
