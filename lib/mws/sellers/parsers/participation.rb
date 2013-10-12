require 'peddler/parsers/model'

module MWS
  module Sellers
    module Parsers
      class Participation < ::Peddler::Parsers::Model
        value(:marketplace_id) do
          text_at_xpath('MarketplaceId')
        end

        value(:seller_id) do
          text_at_xpath('SellerId')
        end

        value(:has_seller_suspended_listings?) do
          boolean_at_xpath('HasSellerSuspendedListings')
        end
      end
    end
  end
end
