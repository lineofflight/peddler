require 'peddler/parsers/model'
require 'mws/sellers/parsers/marketplace'
require 'mws/sellers/parsers/participation'
require 'peddler/parsers/tokenable'

module MWS
  module Sellers
    module Parsers
      class MarketplaceParticipations < ::Peddler::Parsers::Model
        include ::Peddler::Parsers::Tokenable

        value(:marketplaces) do
          marketplace_nodes.map { |node| Marketplace.new(node) }
        end

        value(:participations) do
          participation_nodes.map { |node| Participation.new(node) }
        end

        private

        def participation_nodes
          xpath('ListParticipations/Participation')
        end

        def marketplace_nodes
          xpath('ListMarketplaces/Marketplace')
        end
      end
    end
  end
end
