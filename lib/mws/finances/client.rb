require 'peddler/client'

module MWS
  module Finances
    # With the MWS Finances API you can retrieve financial transactions for your seller account.
    class Client < ::Peddler::Client
      version "2015-05-01"
      path "/Finances/#{version}"

      # Lists financial events
      #
      # @see http://docs.developer.amazonservices.com/en_US/finances/Finances_ListFinancialEvents.html
      # @param opts [Hash]
      # @option opts [Integer] :max_results_per_page
      # @option opts [String] :amazon_order_id
      # @option opts [String] :financial_event_group_id
      # @option opts [String, #iso8601] :posted_after
      # @option opts [String, #iso8601] :posted_before
      # @return [Peddler::XMLParser]
      def list_financial_events(opts = {})
        operation('ListFinancialEvents').add(opts)
        run
      end

      # Lists the next page of financial events
      #
      # @see http://docs.developer.amazonservices.com/en_US/finances/Finances_ListFinancialEventGroupsByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_financial_events_by_next_token(next_token)
        operation('ListFinancialEventsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Lists financial event groups
      #
      # @see http://docs.developer.amazonservices.com/en_US/finances/Finances_ListFinancialEventGroups.html
      # @param financial_event_group_started_after [String, #iso8601]
      # @param opts [Hash]
      # @option opts [Integer] :max_results_per_page
      # @option opts [String, #iso8601] :financial_event_group_started_before
      # @return [Peddler::XMLParser]
      def list_financial_event_groups(financial_event_group_started_after, opts = {})
        operation('ListFinancialEventGroups')
          .add('FinancialEventGroupStartedAfter' => financial_event_group_started_after)
          .add(opts)

        run
      end

      # Lists the next page of financial event groups
      #
      # @see http://docs.developer.amazonservices.com/en_US/finances/Finances_ListFinancialEventGroupsByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_financial_event_groups_by_next_token(next_token)
        operation('ListFinancialEventGroupsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets API status
      #
      # @see http://docs.developer.amazonservices.com/en_US/finances/Finances_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')

        run
      end
    end
  end
end
