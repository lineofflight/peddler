# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Shipping
    #
    # Provides programmatic access to Amazon Shipping APIs. **Note:** If you are new to the Amazon Shipping API, refer
    # to the latest version of <a
    # href="https://developer-docs.amazon.com/amazon-shipping/docs/shipping-api-v2-reference">Amazon Shipping API
    # (v2)</a> on the <a href="https://developer-docs.amazon.com/amazon-shipping/">Amazon Shipping Developer
    # Documentation</a> site.
    class ShippingV1 < API
      # Create a new shipment.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def create_shipment(body)
        path = "/shipping/v1/shipments"

        rate_limit(5.0).post(path, body:)
      end

      # Return the entire shipment object for the shipmentId.
      #
      # @param [String] shipment_id
      # @return [Hash] The API response
      def get_shipment(shipment_id)
        path = "/shipping/v1/shipments/#{shipment_id}"

        rate_limit(5.0).get(path)
      end

      # Cancel a shipment by the given shipmentId.
      #
      # @param [String] shipment_id
      # @return [Hash] The API response
      def cancel_shipment(shipment_id)
        path = "/shipping/v1/shipments/#{shipment_id}/cancel"

        rate_limit(5.0).post(path)
      end

      # Purchase shipping labels based on a given rate.
      #
      # @param [String] shipment_id
      # @param [Hash] body
      # @return [Hash] The API response
      def purchase_labels(shipment_id, body)
        path = "/shipping/v1/shipments/#{shipment_id}/purchaseLabels"

        rate_limit(5.0).post(path, body:)
      end

      # Retrieve shipping label based on the shipment id and tracking id.
      #
      # @param [String] shipment_id
      # @param [String] tracking_id
      # @param [Hash] body
      # @return [Hash] The API response
      def retrieve_shipping_label(shipment_id, tracking_id, body)
        path = "/shipping/v1/shipments/#{shipment_id}/containers/#{tracking_id}/label"

        rate_limit(5.0).post(path, body:)
      end

      # Purchase shipping labels.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def purchase_shipment(body)
        path = "/shipping/v1/purchaseShipment"

        rate_limit(5.0).post(path, body:)
      end

      # Get service rates.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def get_rates(body)
        path = "/shipping/v1/rates"

        rate_limit(5.0).post(path, body:)
      end

      # Verify if the current account is valid.
      # @return [Hash] The API response
      def get_account
        path = "/shipping/v1/account"

        rate_limit(5.0).get(path)
      end

      # Return the tracking information of a shipment.
      #
      # @param [String] tracking_id
      # @return [Hash] The API response
      def get_tracking_information(tracking_id)
        path = "/shipping/v1/tracking/#{tracking_id}"

        rate_limit(1.0).get(path)
      end
    end
  end
end
