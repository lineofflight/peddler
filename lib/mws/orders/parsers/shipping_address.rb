require 'peddler/parsers/model'

module MWS
  module Orders
    module Parsers
      class ShippingAddress < ::Peddler::Parsers::Model
        value :name do
          text_at_xpath('Name')
        end

        value :address_lines do
          1.upto(3).map { |i| text_at_xpath("AddressLine#{i}") }.compact
        end

        value :city do
          text_at_xpath('City')
        end

        value :state_or_region do
          text_at_xpath('StateOrRegion')
        end

        value :postal_code do
          text_at_xpath('PostalCode')
        end

        value :country_code do
          text_at_xpath('CountryCode')
        end

        value :phone do
          text_at_xpath('Phone')
        end
      end
    end
  end
end
