require 'peddler/parsers/xml'

module MWS
  module Products
    module Parsers
      class Identifiers < ::Peddler::Parsers::Model

        value :marketplace_id do
          text_at_xpath('MarketplaceASIN/MarketplaceId')
        end

        value :asin do
          text_at_xpath('MarketplaceASIN/ASIN')
        end

        value :seller_id do
          text_at_xpath('SKUIdentifier/SellerId')
        end

        value :seller_sku do
          text_at_xpath('SKUIdentifier/SellerSKU')
        end
      end
    end
  end
end
