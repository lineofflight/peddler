require 'peddler/client'

module MWS
  # With the Fulfillment Inbound Shipment API, you can create and update inbound
  # shipments of inventory in the Amazon Fulfillment Network. You can also
  # also request lists of inbound shipments or inbound shipment items based on
  # criteria that you specify.
  #
  # @todo Not implemented
  class FulfillmentInboundShipment < ::Peddler::Client
    path '/FulfillmentInboundShipment/2010-10-01'

    # Returns the information required to create an inbound shipment
    def create_inbound_shipment_plan
      raise NotImplementedError
    end

    # Creates an inbound shipment
    def create_inbound_shipment
      raise NotImplementedError
    end

    # Updates an existing inbound shipment
    def update_inbound_shipment
      raise NotImplementedError
    end

    # Sends transportation information to Amazon about an inbound shipment
    def put_transport_content
      raise NotImplementedError
    end

    # Requests an estimate of the shipping cost for an inbound shipment
    def estimate_transport_request
      raise NotImplementedError
    end

    # Confirms that you accept the Amazon-partnered shipping estimate and you
    # request that the Amazon-partnered carrier ship your inbound shipment
    def confirm_transport_request
      raise NotImplementedError
    end

    # Returns current transportation information about an inbound shipment
    def get_transport_content
      raise NotImplementedError
    end

    # Voids a previously-confirmed request to ship your inbound shipment using
    # an Amazon-partnered carrier
    def void_transport_request
      raise NotImplementedError
    end

    # Returns PDF document data for printing package labels for an inbound
    # shipment
    def get_package_labels
      raise NotImplementedError
    end

    # Returns PDF document data for printing a bill of lading for an inbound
    # shipment
    def get_bill_of_lading
      raise NotImplementedError
    end

    # Returns a list of inbound shipments based on criteria that you specify
    def list_inbound_shipments
      raise NotImplementedError
    end

    # Returns the next page of inbound shipments
    def list_inbound_shipments_by_next_token
      raise NotImplementedError
    end

    # Returns a list of items in a specified inbound shipment, or a list of
    # items that were updated within a specified time frame
    def list_inbound_shipment_items
      raise NotImplementedError
    end

    # Returns the next page of inbound shipment items
    def list_inbound_shipment_items_by_next_token
      raise NotImplementedError
    end

    # Gets the operational status of the API
    #
    # @see http://docs.developer.amazonservices.com/en_US/fba_inbound/MWS_GetServiceStatus.html
    # @return [Peddler::XMLParser]
    def get_service_status
      operation('GetServiceStatus')
      run
    end
  end
end
