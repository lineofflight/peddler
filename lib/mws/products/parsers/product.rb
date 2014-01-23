require 'peddler/parsers/xml'

module MWS
  module Products
    module Parsers
      class Product < ::Peddler::Parsers::XML

        def identifiers
          Identifiers.new(xpath('Identifiers'))
        end

      end
    end
  end
end
