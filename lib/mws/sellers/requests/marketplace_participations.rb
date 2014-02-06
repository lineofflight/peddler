require 'peddler/request'
require 'mws/sellers/parsers/marketplace_participations'

module MWS
  module Sellers
    module Requests
      class MarketplaceParticipations < ::Peddler::Request
        def list
          parameters('ListMarketplaceParticipations')
            .camelize_keys!

          execute
        end

        def list_by_next_token(token = next_token)
          return false unless token

          parameters('ListMarketplaceParticipationsByNextToken')
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
