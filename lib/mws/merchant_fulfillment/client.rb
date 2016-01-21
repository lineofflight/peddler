require 'peddler/client'

module MWS
  module MerchantFulfillment
    # The Merchant Fulfillment API provides programmatic access to Amazon's
    # Shipping Services for sellers, including competitive rates from
    # Amazon-partnered carriers. Sellers can find out what shipping service
    # offers are available by submitting information about a proposed shipment,
    # such as package size and weight, shipment origin, and delivery date
    # requirements. Sellers can choose from the shipping service offers returned
    # by Amazon, and then purchase shipping labels for fulfilling their orders.
    class Client < ::Peddler::Client
      version '2015-06-01'
      path "/MerchantFulfillment/#{version}"

      # Returns a list of shipping service offers that satisfy the shipment
      # request details that you specify
      #
      # @see http://docs.developer.amazonservices.com/en_US/merch_fulfill/MerchFulfill_GetEligibleShippingServices.html
      # @param [Struct, Hash] shipment_request_details
      # @return [Peddler::XMLParser]
      def get_eligible_shipping_services(shipment_request_details)
        operation('GetEligibleShippingServices')
          .add('ShipmentRequestDetails' => shipment_request_details)

        run
      end

      # Purchases shipping and returns PNG or PDF document data for a shipping
      # label
      #
      # @see http://docs.developer.amazonservices.com/en_US/merch_fulfill/MerchFulfill_CreateShipment.html
      # @param [Struct, Hash] shipment_request_details
      # @param [String] shipping_service_id
      # @param [Hash] opts
      # @option opts [String] :shipping_service_offer_id
      # @return [Peddler::XMLParser]
      def create_shipment(shipment_request_details, shipping_service_id, opts = {})
        operation('CreateShipment')
          .add(
            'ShipmentRequestDetails' => shipment_request_details,
            'ShippingServiceId' => shipping_service_id
          )
          .add(opts)

        run
      end

      # Returns an existing shipment for the ShipmentId value that you specify
      #
      # @see http://docs.developer.amazonservices.com/en_US/merch_fulfill/MerchFulfill_GetShipment.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def get_shipment(shipment_id)
        operation('GetShipment')
          .add(
            'ShipmentId' => shipment_id
          )

        run
      end

      # Cancels an existing shipment and requests a refund for the ShipmentId
      # value that you specify
      #
      # @see http://docs.developer.amazonservices.com/en_US/merch_fulfill/MerchFulfill_CancelShipment.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def cancel_shipment(shipment_id)
        operation('CancelShipment')
          .add(
            'ShipmentId' => shipment_id
          )

        run
      end

      # Gets the operational status of the API
      #
      # @see http://docs.developer.amazonservices.com/en_US/merch_fulfill/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
