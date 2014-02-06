require 'peddler/request'
require 'mws/subscriptions/parsers/registered_destinations'

module MWS
  module Subscriptions
    module Requests
      class RegisteredDestinations < ::Peddler::Request
        def list( marketplace_id = client.marketplace_id)
          parameters('ListRegisteredDestinations')
            .update(marketplace_id: marketplace_id)
            .timestamp!
            .camelize_keys!

          execute
        end
      end
    end
  end
end
