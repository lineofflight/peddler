require 'mws/sellers/requests/marketplace_participations'
require 'mws/sellers/requests/service_status'
require 'peddler/client'

module MWS
  module Sellers
    # The Sellers API lets sellers retrieve information about their seller
    # account, such as the marketplaces they participate in.
    class Client < ::Peddler::Client
      path 'Sellers/2011-07-01'

      # Public: List marketplaces that the seller submitting the request can
      # sell in and her participations, which include seller-specific
      # information in that marketplace.
      #
      # Examples
      #
      #   client.list_marketplace_participations
      #
      # Returns Marketplace Participations.
      def_delegator :marketplace_participations, :list, :list_marketplace_participations

      # Public: List the next page of marketplace participations using the
      # NextToken parameter.
      #
      # Examples
      #
      #   client.list_marketplace_participations_by_next_token
      #
      # Returns Marketplace Participations.
      def_delegator :marketplace_participations, :list_by_next_token, :list_marketplace_participations_by_next_token

      # Public: Get the service status of the API.
      #
      # Examples
      #
      #   client.get_service_status
      #
      # Returns the Service Status.
      def_delegator :service_status, :get, :get_service_status

      private

      def marketplace_participations
        @marketplace_participations ||= Requests::MarketplaceParticipations.new(self)
      end

      def service_status
        @service_status ||= Requests::ServiceStatus.new(self)
      end
    end
  end
end
