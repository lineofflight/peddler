
require "peddler/api"


module Peddler
  class << self
    def merchant_fulfillment_v0(...)
      APIs::MerchantFulfillmentV0.new(...)
    end
  end

  module APIs
        # Selling Partner API for Merchant Fulfillment
    #
        # With the Selling Partner API for Merchant Fulfillment, you can build applications that sellers can use to purchase
    # shipping for non-Prime and Prime orders using Amazon's Buy Shipping Services.
    class MerchantFulfillmentV0 < API
      
      
              # Returns a list of shipping service offers that satisfy the specified shipment request details.
#
        # @note This operation can make a static sandbox call.
        # @param body [Hash] The request schema for the `GetEligibleShipmentServices` operation.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def get_eligible_shipment_services(body, rate_limit: 6.0)
path = "/mfn/v0/eligibleShippingServices"

  meter(rate_limit).post(path, body:)

end

      
              # Returns the shipment information for an existing shipment.
#
        # @note This operation can make a static sandbox call.
        # @param shipment_id [String] The Amazon-defined shipment identifier for the shipment.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def get_shipment(shipment_id, rate_limit: 1.0)
path = "/mfn/v0/shipments/#{shipment_id}"

  meter(rate_limit).get(path)

end

      
              # Cancel the shipment indicated by the specified shipment identifier.
#
        # @note This operation can make a static sandbox call.
        # @param shipment_id [String] The Amazon-defined shipment identifier for the shipment to cancel.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def cancel_shipment(shipment_id, rate_limit: 1.0)
path = "/mfn/v0/shipments/#{shipment_id}"

  meter(rate_limit).delete(path)

end

      
              # Create a shipment with the information provided.
#
        # @note This operation can make a static sandbox call.
        # @param body [Hash] The request schema for the `CreateShipment` operation.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def create_shipment(body, rate_limit: 2.0)
path = "/mfn/v0/shipments"

  meter(rate_limit).post(path, body:)

end

      
              # Gets a list of additional seller inputs required for a ship method. This is generally used for international
      # shipping.
#
        # @note This operation can make a static sandbox call.
        # @param body [Hash] The request schema for the `GetAdditionalSellerInputs` operation.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def get_additional_seller_inputs(body, rate_limit: 1.0)
path = "/mfn/v0/additionalSellerInputs"

  meter(rate_limit).post(path, body:)

end

      
    end
  end
end
