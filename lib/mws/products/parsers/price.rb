require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class Price < ::Peddler::Parsers::Model

        [:landed_price, :listing_price, :shipping].each do |key|
          value key do
            money_at_xpath(symbol_to_xpath(key))
          end
        end

      end
    end
  end
end
