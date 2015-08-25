require 'peddler/client'

module MWS
  module CartInformation
    # With the Cart Information API, you can retrieve shopping carts that your
    # Amazon Webstore customers have created. The Cart Information API enables
    # you to programmatically integrate Amazon Webstore cart information with
    # your CRM systems, marketing applications, and other systems that require
    # cart data.
    #
    # @note The Cart Information API only returns cart information for Webstores
    #   with Seller-Branded Checkout. No cart information is returned for Amazon
    #   Webstores with Amazon.com checkout. If your Webstore offers both
    #   checkout options, cart information is returned only for Seller-Branded
    #   Checkout accounts.
    # @note In addition to registering for Amazon MWS, you must also request
    #   authorization to use the Cart Information API section.
    class Client < ::Peddler::Client
      version "2014-03-01"
      path "/CartInformation/#{version}"

      # Lists shopping carts
      #
      # @see http://docs.developer.amazonservices.com/en_US/cart_info/CartInfo_ListCarts.html
      # @param date_range_start [String, #iso8601]
      # @param opts [Hash]
      # @option opts [String] :marketplace_id
      # @option opts [String, #iso8601] :date_range_end
      # @return [Peddler::XMLParser]
      def list_carts(date_range_start, opts = {})
        operation('ListCarts')
          .add(opts.update('DateRangeStart' => date_range_start))

        run
      end

      # Lists the next page of shopping carts
      #
      # @see http://docs.developer.amazonservices.com/en_US/cart_info/CartInfo_ListCartsByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_carts_by_next_token(next_token)
        operation('ListCartsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Returns shopping carts based on specified values
      #
      # @see http://docs.developer.amazonservices.com/en_US/cart_info/CartInfo_GetCarts.html
      # @param marketplace_id [String]
      # @param cart_id_list [Array<String>]
      # @return [Peddler::XMLParser]
      def get_carts(marketplace_id, *cart_id_list)
        operation('GetCarts')
          .add('MarketplaceId' => marketplace_id, 'CartIdList' => cart_id_list)
          .structure!('CartIdList', 'CartId')

        run
      end

      # Gets the service status of the API
      #
      # @see http://docs.developer.amazonservices.com/en_US/cart_info/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
