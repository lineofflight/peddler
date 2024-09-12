# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Merchant Fulfillment
    #
    # The Selling Partner API for Merchant Fulfillment helps you build applications that let sellers purchase shipping
    # for non-Prime and Prime orders using Amazon’s Buy Shipping Services.
    class MerchantFulfillmentV0 < API
      # Returns a list of shipping service offers that satisfy the specified shipment request details.
      #
      # @param [Hash] body Request schema for GetEligibleShipmentServices operation.
      # @return [Hash] The API response
      def get_eligible_shipment_services(body)
        path = "/mfn/v0/eligibleShippingServices"
        body = body

        rate_limit(5.0).post(path, body:)
      end

      # Returns the shipment information for an existing shipment.
      #
      # @param [String] shipment_id The Amazon-defined shipment identifier for the shipment.
      # @return [Hash] The API response
      def get_shipment(shipment_id)
        path = "/mfn/v0/shipments/#{shipment_id}"

        rate_limit(1.0).get(path)
      end

      # Cancel the shipment indicated by the specified shipment identifier.
      #
      # @param [String] shipment_id The Amazon-defined shipment identifier for the shipment to cancel.
      # @return [Hash] The API response
      def cancel_shipment(shipment_id)
        path = "/mfn/v0/shipments/#{shipment_id}"

        rate_limit(1.0).delete(path)
      end

      # Create a shipment with the information provided.
      #
      # @param [Hash] body Request schema for CreateShipment operation.
      # @return [Hash] The API response
      def create_shipment(body)
        path = "/mfn/v0/shipments"
        body = body

        rate_limit(1.0).post(path, body:)
      end

      # Gets a list of additional seller inputs required for a ship method. This is generally used for international
      # shipping.
      #
      # @param [Hash] body Request schema for GetAdditionalSellerInputs operation.
      # @return [Hash] The API response
      def get_additional_seller_inputs(body)
        path = "/mfn/v0/additionalSellerInputs"
        body = body

        rate_limit(1.0).post(path, body:)
      end
    end
  end
end
