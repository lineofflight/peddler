require 'peddler/client'
require 'excon'

module MWS
  # The Fulfillment Outbound Shipment API enables you to fulfill orders placed
  # through channels other than Amazon's retail web site, using your inventory
  # in the Amazon Fulfillment Network. You can request previews of potential
  # fulfillment orders that return estimated shipping fees and shipping dates
  # based on shipping speed. You can get detailed item-level, shipment-level,
  # and order-level information for any existing fulfillment order that you
  # specify. You can also request lists of existing fulfillment orders based on
  # when they were fulfilled and by the fulfillment method associated with them.
  #
  # @todo Not implemented
  class FulfillmentOutboundShipment < ::Peddler::Client
    path '/FulfillmentOutboundShipment/2010-10-01'

    # Lists fulfillment order previews
    def get_fulfillment_preview
      raise NotImplementedError
    end

    # Requests that Amazon ship items from the seller's Amazon Fulfillment
    # Network inventory to a destination address
    #
    # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_CreateFulfillmentOrder.html
    # @param sellerFulfillmentOrderId [String]
    # @param displayableOrderId [String]
    # @param displayableOrderDateTime [String]
    # @param displayableOrderComment [String]
    # @param shippingSpeedCategory [String]
    # @param destinationAddress [Address hash.  See http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_Datatypes.html#Address]
    # @params Items [Array of CreateFulfillmentOrderItem. See http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_Datatypes.html#CreateFulfillmentOrderItem]
    # @param address [Hash]
    # @option items [Array] 
    # @param opts [Hash]
    # @return [Peddler::XMLParser]
    
    def create_fulfillment_order(sellerFulfillmentOrderId, displayableOrderId, displayableOrderDateTime,
      displayableOrderComment, shippingSpeedCategory, destinationAddress, items, opts = {})
      opts.merge!('SellerFulfillmentOrderId' => sellerFulfillmentOrderId,
                  'DisplayableOrderId' => displayableOrderId,
                  'DisplayableOrderDateTime' => displayableOrderDateTime,
                  'DisplayableOrderComment' => displayableOrderComment,
                  'ShippingSpeedCategory' => shippingSpeedCategory,
                  'DestinationAddress' => destinationAddress,
                  'Items' => items)
      operation('CreateFulfillmentOrder')
        .add(opts)
        .structure!('Items', 'member')
      run
      
    end

    # Updates and/or requests shipment for a fulfillment order with an order
    # hold on it
    def update_fulfillment_order
      raise NotImplementedError
    end

    # Gets a fulfillment order
    def get_fulfillment_order
      raise NotImplementedError
    end

    # Returns a list of fulfillment orders fulfilled on or after a date
    def list_all_fulfillment_orders
      raise NotImplementedError
    end

    # Returns the next page of fulfillment orders
    def list_all_fulfillment_orders_by_next_token
      raise NotImplementedError
    end

    # Returns delivery tracking information for a package in an outbound
    # shipment for a Multi-Channel Fulfillment order
    def get_package_tracking_details
      raise NotImplementedError
    end

    # Requests that Amazon stop attempting to fulfill an existing fulfillment
    # order
    # Note: orders are not cancellable immediately when created; wait a few minutes or you 
    # will get a 500 error from MWS
    #
    # @see http://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_CancelFulfillmentOrder.html
    # @param order_id [String]
    # @return [Peddler::XMLParser]
    
    def cancel_fulfillment_order(order_id)
      operation('CancelFulfillmentOrder').add('SellerFulfillmentOrderId' => order_id)
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
