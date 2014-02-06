require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class MarketplaceASIN < ::Peddler::Parsers::Model
        value :marketplace_id do
          text_at_xpath('MarketplaceId')
        end

        value :asin do
          text_at_xpath('ASIN')
        end
      end
    end
  end
end
