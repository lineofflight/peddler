require 'peddler/client'
require 'excon'

module MWS
  module FulfillmentOutboundShipment
    # The Fulfillment Outbound Shipment API enables you to fulfill orders placed
    # through channels other than Amazon's retail web site, using your inventory
    # in the Amazon Fulfillment Network. You can request previews of potential
    # fulfillment orders that return estimated shipping fees and shipping dates
    # based on shipping speed. You can get detailed item-level, shipment-level,
    # and order-level information for any existing fulfillment order that you
    # specify. You can also request lists of existing fulfillment orders based
    # on when they were fulfilled and by the fulfillment method associated with
    # them.
    class Client < ::Peddler::Client
      version "2010-10-01"
      path "/FulfillmentOutboundShipment/#{version}"

      # Lists fulfillment order previews
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_GetFulfillmentPreview.html
      # @param address [Struct, Hash]
      # @param items [Array<Struct, Hash>]
      # @param opts [Hash]
      # @option opts Array[String] :shipping_speed_categories
      # @option opts [Boolean] :include_cod_fulfillment_preview
      # @return [Peddler::XMLParser]
      def get_fulfillment_preview(address, items, opts = {})
        if opts.key?(:include_cod_fulfillment_preview)
          opts['IncludeCODFulfillmentPreview'] = opts.delete(:include_cod_fulfillment_preview)
        end

        operation('GetFulfillmentPreview')
          .add(opts.update('Address' => address, 'Items' => items))
          .structure!('Items', 'member')
          .structure!('ShippingSpeedCategories')

        run
      end

      # Requests that Amazon ship items from the seller's Amazon Fulfillment
      # Network inventory to a destination address
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_CreateFulfillmentOrder.html
      # @param seller_fulfillment_order_id [String]
      # @param displayable_order_id [String]
      # @param displayable_order_date_time [String, #iso8601]
      # @param displayable_order_comment [String]
      # @param shipping_speed_category [String]
      # @param destination_address [Struct, Hash]
      # @param items [Array<Struct, Hash>]
      # @param opts [Hash]
      # @option opts [String] :fulfillment_action
      # @option opts [String] :fulfillment_policy
      # @option opts [Array<String>] :notification_email_list
      # @option opts [Struct, Hash] :cod_settings
      # @return [Peddler::XMLParser]
      # rubocop:disable MethodLength, ParameterLists
      def create_fulfillment_order(seller_fulfillment_order_id, displayable_order_id, displayable_order_date_time, displayable_order_comment, shipping_speed_category, destination_address, items, opts = {})
        if opts.key?(:cod_settings)
          opts['CODSettings'] = opts.delete(:cod_settings)
        end

        operation('CreateFulfillmentOrder')
          .add(opts
            .merge(
              'SellerFulfillmentOrderId' => seller_fulfillment_order_id,
              'DisplayableOrderId' => displayable_order_id,
              'DisplayableOrderDateTime' => displayable_order_date_time,
              'DisplayableOrderComment' => displayable_order_comment,
              'ShippingSpeedCategory' => shipping_speed_category,
              'DestinationAddress' => destination_address,
              'Items' => items
            )
              )
          .structure!('Items', 'member')
          .structure!('NotificationEmailList', 'member')

        run
      end

      # Updates and/or requests shipment for a fulfillment order with an order
      # hold on it
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_UpdateFulfillmentOrder.html
      # @param seller_fulfillment_order_id [String]
      # @param opts [Hash]
      # @option opts [String] :fulfillment_action
      # @option opts [String] :displayable_order_id
      # @option opts [String, #iso8601] :displayable_order_date_time
      # @option opts [String] :displayable_order_comment
      # @option opts [String] :shipping_speed_category
      # @option opts [Struct, Hash] :destination_address
      # @option opts [String] :fulfillment_policy
      # @option opts [Array<String>] :notification_email_list
      # @option opts [Array<Struct, Hash>] :items
      # @return [Peddler::XMLParser]
      def update_fulfillment_order(seller_fulfillment_order_id, opts = {})
        operation('UpdateFulfillmentOrder')
          .add(opts.update('SellerFulfillmentOrderId' => seller_fulfillment_order_id))
          .structure!('NotificationEmailList', 'member')
          .structure!('Items', 'member')

        run
      end

      # Gets a fulfillment order
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_GetFulfillmentOrder.html
      # @param seller_fulfillment_order_id [String]
      # @return [Peddler::XMLParser]
      def get_fulfillment_order(seller_fulfillment_order_id)
        operation('GetFulfillmentOrder')
          .add('SellerFulfillmentOrderId' => seller_fulfillment_order_id)

        run
      end

      # Returns a list of fulfillment orders fulfilled on or after a date
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_ListAllFulfillmentOrders.html
      # @param query_start_date_time [String, #iso8601]
      # @return [Peddler::XMLParser]
      def list_all_fulfillment_orders(query_start_date_time = nil)
        opts = query_start_date_time ? { 'QueryStartDateTime' => query_start_date_time } : {}
        operation('ListAllFulfillmentOrders').add(opts)

        run
      end

      # Returns the next page of fulfillment orders
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_ListAllFulfillmentOrdersByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_all_fulfillment_orders_by_next_token(next_token)
        operation('ListAllFulfillmentOrdersByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Returns delivery tracking information for a package in an outbound
      # shipment for a Multi-Channel Fulfillment order
      def get_package_tracking_details
        fail NotImplementedError
      end

      # Requests that Amazon stop attempting to fulfill an existing fulfillment
      # order
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_CancelFulfillmentOrder.html
      # @param seller_fulfillment_order_id [String]
      # @return [Peddler::XMLParser]
      def cancel_fulfillment_order(seller_fulfillment_order_id)
        operation('CancelFulfillmentOrder')
          .add('SellerFulfillmentOrderId' => seller_fulfillment_order_id)

        run
      end

      # Gets the operational status of the API
      #
      # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
