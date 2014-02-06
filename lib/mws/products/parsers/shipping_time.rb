require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class ShippingTime < ::Peddler::Parsers::Model
        value :max do
          text_at_xpath('Max')
        end
      end
    end
  end
end

