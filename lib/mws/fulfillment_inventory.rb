require 'peddler/client'

module MWS
  # The Fulfillment Inventory API can help you stay up-to-date on the
  # availability of your inventory in the Amazon Fulfillment Network. The
  # Fulfillment Inventory API reports real-time availability information for
  # your Amazon Fulfillment Network inventory regardless of whether you are
  # selling your inventory on Amazon's retail web site or through other retail
  # channels.
  #
  # @todo Not implemented
  class FulfillmentInventory < ::Peddler::Client
    path '/FulfillmentInventory/2010-10-01'

    # Returns information about the availability of a seller's inventory
    def list_inventory_supply
      raise NotImplementedError
    end

    # Returns the next page of information about the availability of a seller's
    # inventory
    def list_inventory_supply_by_next_token
      raise NotImplementedError
    end

    # Gets the operational status of the API
    #
    # @see http://docs.developer.amazonservices.com/en_US/fba_inventory/MWS_GetServiceStatus.html
    # @return [Peddler::XMLParser]
    def get_service_status
      operation('GetServiceStatus')
      run
    end
  end
end
