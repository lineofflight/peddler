# frozen_string_literal: true

require 'peddler/client'

module MWS
  module Recommendations
    # The Recommendations API enables you to programmatically retrieve Amazon
    # Selling Coach recommendations by recommendation category. A recommendation
    # is an actionable, timely, and personalized opportunity to increase your
    # sales and performance.
    class Client < ::Peddler::Client
      version '2013-04-01'
      path "/Recommendations/#{version}"

      # Checks whether there are active recommendations for each category for
      # the given marketplace, and if there are, returns the time when
      # recommendations were last updated for each category
      #
      # @see https://docs.developer.amazonservices.com/en_US/recommendations/Recommendations_GetLastUpdatedTimeForRecommendations.html
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def get_last_updated_time_for_recommendations(marketplace_id)
        operation('GetLastUpdatedTimeForRecommendations')
          .add('MarketplaceId' => marketplace_id)

        run
      end

      # Lists active recommendations for a specific category or for all
      # categories for a specific marketplace
      #
      # @see https://docs.developer.amazonservices.com/en_US/recommendations/Recommendations_ListRecommendations.html
      # @overload list_recommendations(marketplace_id, opts = {})
      #   @param [Hash] opts
      #   @option opts [String] :marketplace_id
      #   @option opts [String] :recommendation_category
      #   @option opts [Array<Struct, Hash>] :category_query_list
      # @return [Peddler::XMLParser]
      def list_recommendations(marketplace_id, opts = {})
        operation('ListRecommendations')
          .add(opts.update('MarketplaceId' => marketplace_id))
          .structure!(
            'CategoryQueryList', 'CategoryQuery', '1', 'FilterOptions',
            'FilterOption'
          )

        run
      end

      # Lists the next page of active recommendations
      #
      # @see https://docs.developer.amazonservices.com/en_US/recommendations/Recommendations_ListRecommendationsByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def list_recommendations_by_next_token(next_token)
        operation('ListRecommendationsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets the service status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/recommendations/Recommendations_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
