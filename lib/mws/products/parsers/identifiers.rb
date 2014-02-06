require 'peddler/parsers/model'
require 'mws/products/parsers/sku_identifier'
require 'mws/products/parsers/marketplace_asin'

module MWS
  module Products
    module Parsers
      class Identifiers < ::Peddler::Parsers::Model
        value :marketplace_asin do
          node = at_xpath('MarketplaceASIN')
          MarketplaceASIN.new(node)
        end

        value :sku_identifier do
          node = at_xpath('SKUIdentifier')
          SKUIdentifier.new(node) if node
        end
      end
    end
  end
end
