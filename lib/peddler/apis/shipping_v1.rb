# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Shipping
    #
    # Provides programmatic access to Amazon Shipping APIs.
    #
    # **Note:** If you are new to the Amazon Shipping API, refer to the latest version of
    # {https://developer-docs.amazon.com/amazon-shipping/docs/shipping-api-v2-reference Amazon Shipping API (v2)} on the
    # {https://developer-docs.amazon.com/amazon-shipping/ Amazon Shipping Developer Documentation} site.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/shipping-api-model/shipping.json
    class ShippingV1 < API
      # Create a new shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] CreateShipmentRequest Body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_shipment(body, rate_limit: 5.0)
        path = "/shipping/v1/shipments"
        parser = -> { CreateShipmentResponse }
        meter(rate_limit).post(path, body:, parser:)
      end

      # Return the entire shipment object for the shipmentId.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] Shipment id to return the entire shipment object
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment(shipment_id, rate_limit: 5.0)
        path = "/shipping/v1/shipments/#{percent_encode(shipment_id)}"
        parser = -> { GetShipmentResponse }
        meter(rate_limit).get(path, parser:)
      end

      # Cancel a shipment by the given shipmentId.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] Shipment Id to cancel a shipment
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_shipment(shipment_id, rate_limit: 5.0)
        path = "/shipping/v1/shipments/#{percent_encode(shipment_id)}/cancel"
        parser = -> { CancelShipmentResponse }
        meter(rate_limit).post(path, parser:)
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
        parser = -> { PurchaseLabelsResponse }
        meter(rate_limit).post(path, body:, parser:)
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
        parser = -> { RetrieveShippingLabelResponse }
        meter(rate_limit).post(path, body:, parser:)
      end

      # Purchase shipping labels.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] PurchaseShipmentRequest body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def purchase_shipment(body, rate_limit: 5.0)
        path = "/shipping/v1/purchaseShipment"
        parser = -> { PurchaseShipmentResponse }
        meter(rate_limit).post(path, body:, parser:)
      end

      # Get service rates.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] GetRatesRequest body
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_rates(body, rate_limit: 5.0)
        path = "/shipping/v1/rates"
        parser = -> { GetRatesResponse }
        meter(rate_limit).post(path, body:, parser:)
      end

      # Verify if the current account is valid.
      #
      # @note This operation can make a static sandbox call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_account(rate_limit: 5.0)
        path = "/shipping/v1/account"
        parser = -> { GetAccountResponse }
        meter(rate_limit).get(path, parser:)
      end

      # Return the tracking information of a shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param tracking_id [String] Tracking Id
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_tracking_information(tracking_id, rate_limit: 1.0)
        path = "/shipping/v1/tracking/#{percent_encode(tracking_id)}"
        parser = -> { GetTrackingInformationResponse }
        meter(rate_limit).get(path, parser:)
      end
    end
  end
end
