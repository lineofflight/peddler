require 'peddler/client'

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
    def create_fulfillment_order
      raise NotImplementedError
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
    def cancel_fulfillment_order
      raise NotImplementedError
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
