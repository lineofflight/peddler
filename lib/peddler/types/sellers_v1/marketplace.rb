# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SellersV1
      # Information about an Amazon marketplace where a seller can list items and customers can view and purchase items.
      Marketplace = Structure.new do
        # @return [String] The encrypted marketplace value.
        attribute(:id, String)

        # @return [String] The marketplace name.
        attribute(:name, String)

        # @return [String] The ISO 3166-1 alpha-2 format country code of the marketplace.
        attribute(:country_code, String, from: "countryCode")

        # @return [String] The ISO 4217 format currency code of the marketplace.
        attribute(:default_currency_code, String, from: "defaultCurrencyCode")

        # @return [String] The ISO 639-1 format language code of the marketplace.
        attribute(:default_language_code, String, from: "defaultLanguageCode")

        # @return [String] The domain name of the marketplace.
        attribute(:domain_name, String, from: "domainName")
      end
    end
  end
end
