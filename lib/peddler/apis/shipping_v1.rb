# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def shipping_v1(...)
      APIs::ShippingV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Shipping
    #
    # Provides programmatic access to Amazon Shipping APIs.
    #
    # **Note:** If you are new to the Amazon Shipping API, refer to the latest version of <a
    # href="https://developer-docs.amazon.com/amazon-shipping/docs/shipping-api-v2-reference">Amazon Shipping API
    # (v2)</a> on the <a href="https://developer-docs.amazon.com/amazon-shipping/">Amazon Shipping Developer
    # Documentation</a> site.
    class ShippingV1 < API
      # Create a new shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] CreateShipmentRequest Body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_shipment(body, rate_limit: 5.0)
        path = "/shipping/v1/shipments"

        meter(rate_limit).post(path, body:)
      end

      # Return the entire shipment object for the shipmentId.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] Shipment id to return the entire shipment object
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment(shipment_id, rate_limit: 5.0)
        path = "/shipping/v1/shipments/#{percent_encode(shipment_id)}"

        meter(rate_limit).get(path)
      end

      # Cancel a shipment by the given shipmentId.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] Shipment Id to cancel a shipment
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_shipment(shipment_id, rate_limit: 5.0)
        path = "/shipping/v1/shipments/#{percent_encode(shipment_id)}/cancel"

        meter(rate_limit).post(path)
      end

      # Purchase shipping labels based on a given rate.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] Shipment id for purchase shipping label
      # @param body [Hash] PurchaseShippingLabelRequest body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def purchase_labels(shipment_id, body, rate_limit: 5.0)
        path = "/shipping/v1/shipments/#{percent_encode(shipment_id)}/purchaseLabels"

        meter(rate_limit).post(path, body:)
      end

      # Retrieve shipping label based on the shipment id and tracking id.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] Shipment Id to retreive label
      # @param tracking_id [String] Tracking Id
      # @param body [Hash] RetrieveShippingLabelRequest body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def retrieve_shipping_label(shipment_id, tracking_id, body, rate_limit: 5.0)
        path = "/shipping/v1/shipments/#{percent_encode(shipment_id)}/containers/#{percent_encode(tracking_id)}/label"

        meter(rate_limit).post(path, body:)
      end

      # Purchase shipping labels.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] PurchaseShipmentRequest body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def purchase_shipment(body, rate_limit: 5.0)
        path = "/shipping/v1/purchaseShipment"

        meter(rate_limit).post(path, body:)
      end

      # Get service rates.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] GetRatesRequest body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_rates(body, rate_limit: 5.0)
        path = "/shipping/v1/rates"

        meter(rate_limit).post(path, body:)
      end

      # Verify if the current account is valid.
      #
      # @note This operation can make a static sandbox call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_account(rate_limit: 5.0)
        path = "/shipping/v1/account"

        meter(rate_limit).get(path)
      end

      # Return the tracking information of a shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param tracking_id [String] Tracking Id
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_tracking_information(tracking_id, rate_limit: 1.0)
        path = "/shipping/v1/tracking/#{percent_encode(tracking_id)}"

        meter(rate_limit).get(path)
      end
    end
  end
end
