require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class SKUIdentifier < ::Peddler::Parsers::Model
        value :marketplace_id do
          text_at_xpath('MarketplaceId')
        end

        value :seller_id do
          text_at_xpath('SellerId')
        end

        value :seller_sku do
          text_at_xpath('SellerSKU')
        end
      end
    end
  end
end
