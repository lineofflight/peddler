# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      # Information about an Amazon marketplace where a seller can list items and customers can view and purchase items.
      Marketplace = Structure.new do
        # The ISO 3166-1 alpha-2 format country code of the marketplace.
        attribute(:country_code, String, null: false, from: "countryCode")

        # The ISO 4217 format currency code of the marketplace.
        attribute(:default_currency_code, String, null: false, from: "defaultCurrencyCode")

        # The ISO 639-1 format language code of the marketplace.
        attribute(:default_language_code, String, null: false, from: "defaultLanguageCode")

        # The domain name of the marketplace.
        attribute(:domain_name, String, null: false, from: "domainName")

        # The encrypted marketplace value.
        attribute(:id, String, null: false)

        # The marketplace name.
        attribute(:name, String, null: false)
      end
    end
  end
end
