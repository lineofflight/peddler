require 'peddler/request'
require 'mws/sellers/parsers/marketplace_participations'

module MWS
  module Sellers
    module Requests
      class MarketplaceParticipations < ::Peddler::Request
        def list
          parameters(:list_marketplace_participations)
            .camelize_keys!

          execute
        end

        def list_by_next_token(token = next_token)
          return false unless token

          parameters(:list_marketplace_participations_by_next_token)
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
