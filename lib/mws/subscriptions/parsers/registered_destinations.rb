require 'peddler/parsers/collection'
require 'mws/subscriptions/parsers/registered_destination'

module MWS
  module Subscriptions
    module Parsers
      class RegisteredDestinations < ::Peddler::Parsers::Collection
        def each(&blk)
          registered_destination_nodes.each { |node| yield RegisteredDestination.new(node) }
        end

        private

        def registered_destination_nodes
          xpath('DestinationList/member')
        end
      end
    end
  end
end
