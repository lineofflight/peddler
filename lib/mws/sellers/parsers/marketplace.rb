require 'peddler/parsers/model'

module MWS
  module Sellers
    module Parsers
      class Marketplace < ::Peddler::Parsers::Model
        value(:id) do
          text_at_xpath('MarketplaceId')
        end

        value(:name) do
          text_at_xpath('Name')
        end

        value(:default_country_code) do
          text_at_xpath('DefaultCountryCode')
        end

        value(:default_currency_code) do
          text_at_xpath('DefaultCurrencyCode')
        end

        value(:default_language_code) do
          text_at_xpath('DefaultLanguageCode')
        end

        value(:domain_name) do
          text_at_xpath('DomainName')
        end
      end
    end
  end
end
