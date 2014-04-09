require 'peddler/client'

module MWS
  # The Sellers API lets sellers retrieve information about their seller
  # account, such as the marketplaces they participate in.
  class Sellers < ::Peddler::Client
    path 'Sellers/2011-07-01'

    # Lists the marketplaces the seller participates in
    #
    # @see http://docs.developer.amazonservices.com/en_US/sellers/Sellers_ListMarketplaceParticipations.html
    # @param next_token [String]
    # @return [Peddler::XMLParser]
    def list_marketplace_participations
      operation('ListMarketplaceParticipations')
      run
    end

    # Lists the next page of marketplaces the seller participates in
    #
    # @see http://docs.developer.amazonservices.com/en_US/sellers/Sellers_ListMarketplaceParticipationsByNextToken.html
    # @param next_token [String]
    # @return [Peddler::XMLParser]
    def list_marketplace_participations_by_next_token(next_token)
      operation('ListMarketplaceParticipationsByNextToken')
        .add('NextToken' => next_token)

      run
    end

    # Gets the service status of the API
    #
    # @see http://docs.developer.amazonservices.com/en_US/sellers/MWS_GetServiceStatus.html
    # @return [Peddler::XMLParser]
    def get_service_status
      operation('GetServiceStatus')
      run
    end
  end
end
