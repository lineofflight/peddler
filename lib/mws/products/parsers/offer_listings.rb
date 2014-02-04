require 'peddler/parsers/xml'

module MWS
  module Products
    module Parsers
      class OfferListings < ::Peddler::Parsers::XML

        def product
          Product.new(xpath('Product'))
        end

      end
    end
  end
end
