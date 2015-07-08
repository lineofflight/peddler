require 'peddler/client'

module MWS
  module Webstore
    # With the Webstore API section of Amazon MWS, you can get "Email Me When
    # Available" subscription information for items listed on your Amazon
    # Webstore. The Webstore API section can help you plan your inventory
    # replenishment cycle by enabling you to query for items that your customers
    # subscribed to when they clicked the Email Me When Available button on your
    # Webstore. The Webstore API section can also return information about the
    # notifications that were sent to your customers when out-of-stock items
    # came back in stock. This information, when combined with sales information
    # that your Webstore tracks, can help you determine how many notifications
    # were converted into sales.
    class Client < ::Peddler::Client
      version "2014-09-01"
      path "/Webstore/#{version}/"

      # Lists subscription counts of subscriptions in a specified state,
      # including the items that are subscribed to
      #
      # @see http://docs.developer.amazonservices.com/en_US/webstore/Webstore_ListSubscriptionsCount.html
      # @overload list_subscriptions_count(subscription_state, opts = { marketplace_id: primary_marketplace_id })
      #   @param subscription_state [String]
      #   @param opts [Hash]
      #   @option opts [String] :marketplace_id
      #   @option opts [String, #iso8601] :date_range_start
      #   @option opts [String, #iso8601] :date_range_end
      #   @option opts [Array<String>] :seller_sku_list
      # @return [Peddler::XMLParser]
      def list_subscriptions_count(subscription_state, opts = {})
        opts[:marketplace_id] ||= primary_marketplace_id
        if opts.key?(:seller_sku_list)
          opts['SellerSKUList'] = opts.delete(:seller_sku_list)
        end
        operation('ListSubscriptionsCount')
          .add(opts.update('SubscriptionState' => subscription_state))
          .structure!('SellerSKUList', 'SellerSKU')

        run
      end

      # Lists the next page of subscription counts
      #
      # @see http://docs.developer.amazonservices.com/en_US/webstore/Webstore_ListSubscriptionsCountByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_subscriptions_count_by_next_token(next_token)
        operation('ListSubscriptionsCountByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets the number of subscriptions that were created or notifications that
      # were sent for an item within a date range
      #
      # @see http://docs.developer.amazonservices.com/en_US/webstore/Webstore_ListSubscriptionsCount.html
      # @overload get_subscription_details(seller_sku, subscription_state, date_range_start, opts = { marketplace_id: marketplace_id })
      #   @param seller_sku [String]
      #   @param subscription_state [String]
      #   @param date_range_start [String, #iso8601]
      #   @param opts [Hash]
      #   @option opts [String] :marketplace_id
      #   @option opts [String, #iso8601] :date_range_end
      # @return [Peddler::XMLParser]
      def get_subscription_details(seller_sku, subscription_state, date_range_start, opts = {})
        opts[:marketplace_id] ||= primary_marketplace_id
        operation('GetSubscriptionDetails')
          .add(opts.update(
                 'SellerSKU' => seller_sku,
                 'SubscriptionState' => subscription_state,
                 'DateRangeStart' => date_range_start
          ))

        run
      end

      # Gets the service status of the API
      #
      # @see http://docs.developer.amazonservices.com/en_US/webstore/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
