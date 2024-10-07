# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def shipping_v2(...)
      API::ShippingV2.new(...)
    end
  end

  class API
    # Amazon Shipping API
    #
    # The Amazon Shipping API is designed to support outbound shipping use cases both for orders originating on
    # Amazon-owned marketplaces as well as external channels/marketplaces. With these APIs, you can request shipping
    # rates, create shipments, cancel shipments, and track shipments.
    class ShippingV2 < API
      # Returns the available shipping service offerings.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_rates(body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/shipments/rates"

        meter(rate_limit).post(path, body:)
      end

      # Purchases the shipping service for a shipment using the best fit service offering. Returns purchase related
      # details and documents.
      #
      # @param body [Hash]
      # @param x_amzn_idempotency_key [String] A unique value which the server uses to recognize subsequent retries of
      #   the same request.
      # @param locale [String] The IETF Language Tag. Note that this only supports the primary language subtag with one
      #   secondary language subtag (i.e. en-US, fr-CA). The secondary language subtag is almost always a regional
      #   designation. This does not support additional subtags beyond the primary and secondary language subtags.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def direct_purchase_shipment(body, x_amzn_idempotency_key: nil, locale: nil, x_amzn_shipping_business_id: nil,
        rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/shipments/directPurchase"

        meter(rate_limit).post(path, body:)
      end

      # Purchases a shipping service and returns purchase related details and documents. Note: You must complete the
      # purchase within 10 minutes of rate creation by the shipping service provider. If you make the request after the
      # 10 minutes have expired, you will receive an error response with the error code equal to "TOKEN_EXPIRED". If you
      # receive this error response, you must get the rates for the shipment again.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash]
      # @param x_amzn_idempotency_key [String] A unique value which the server uses to recognize subsequent retries of
      #   the same request.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def purchase_shipment(body, x_amzn_idempotency_key: nil, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/shipments"

        meter(rate_limit).post(path, body:)
      end

      # Purchases a shipping service identifier and returns purchase-related details and documents.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def one_click_shipment(body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/oneClickShipment"

        meter(rate_limit).post(path, body:)
      end

      # Returns tracking information for a purchased shipment.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param tracking_id [String] A carrier-generated tracking identifier originally returned by the purchaseShipment
      #   operation.
      # @param carrier_id [String] A carrier identifier originally returned by the getRates operation for the selected
      #   rate.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_tracking(tracking_id, carrier_id, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/tracking"
        params = {
          "trackingId" => tracking_id,
          "carrierId" => carrier_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns the shipping documents associated with a package in a shipment.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param shipment_id [String] The shipment identifier originally returned by the purchaseShipment operation.
      # @param package_client_reference_id [String] The package client reference identifier originally provided in the
      #   request body parameter for the getRates operation.
      # @param format [String] The file format of the document. Must be one of the supported formats returned by the
      #   getRates operation.
      # @param dpi [Number] The resolution of the document (for example, 300 means 300 dots per inch). Must be one of
      #   the supported resolutions returned in the response to the getRates operation.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_shipment_documents(shipment_id, package_client_reference_id, format: nil, dpi: nil,
        x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/shipments/#{shipment_id}/documents"
        params = {
          "packageClientReferenceId" => package_client_reference_id,
          "format" => format,
          "dpi" => dpi,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Cancels a purchased shipment. Returns an empty object if the shipment is successfully cancelled.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param shipment_id [String] The shipment identifier originally returned by the purchaseShipment operation.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def cancel_shipment(shipment_id, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/shipments/#{shipment_id}/cancel"

        meter(rate_limit).put(path)
      end

      # Returns the JSON schema to use for providing additional inputs when needed to purchase a shipping offering. Call
      # the getAdditionalInputs operation when the response to a previous call to the getRates operation indicates that
      # additional inputs are required for the rate (shipping offering) that you want to purchase.
      #
      # @note This operation can make a static sandbox call.
      # @param request_token [String] The request token returned in the response to the getRates operation.
      # @param rate_id [String] The rate identifier for the shipping offering (rate) returned in the response to the
      #   getRates operation.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_additional_inputs(request_token, rate_id, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        path = "/shipping/v2/shipments/additionalInputs/schema"
        params = {
          "requestToken" => request_token,
          "rateId" => rate_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # This API will return a list of input schema required to register a shipper account with the carrier.
      #
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_carrier_account_form_inputs(x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/carrierAccountFormInputs"

        meter(rate_limit).get(path)
      end

      # This API will return Get all carrier accounts for a merchant.
      #
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_carrier_accounts(body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/carrierAccounts"

        meter(rate_limit).put(path, body:)
      end

      # This API associates/links the specified carrier account with the merchant.
      #
      # @param carrier_id [String] The unique identifier associated with the carrier account.
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def link_carrier_account(carrier_id, body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/carrierAccounts/#{carrier_id}"

        meter(rate_limit).put(path, body:)
      end

      # This API Unlink the specified carrier account with the merchant.
      #
      # @param carrier_id [String] carrier Id to unlink with merchant.
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def unlink_carrier_account(carrier_id, body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/carrierAccounts/#{carrier_id}/unlink"

        meter(rate_limit).put(path, body:)
      end

      # This API Call to generate the collection form.
      #
      # @param body [Hash]
      # @param x_amzn_idempotency_key [String] A unique value which the server uses to recognize subsequent retries of
      #   the same request.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def generate_collection_form(body, x_amzn_idempotency_key: nil, x_amzn_shipping_business_id: nil,
        rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/collectionForms"

        meter(rate_limit).post(path, body:)
      end

      # This API Call to get the history of the previously generated collection forms.
      #
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_collection_form_history(body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/collectionForms/history"

        meter(rate_limit).put(path, body:)
      end

      # This API Get all unmanifested carriers with shipment locations. Any locations which has unmanifested shipments
      # with an eligible carrier for manifesting shall be returned.
      #
      # @param body [Hash]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_unmanifested_shipments(body, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/unmanifestedShipments"

        meter(rate_limit).put(path, body:)
      end

      # This API reprint a collection form.
      #
      # @param collection_form_id [String] collection form Id to reprint a collection.
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_collection_form(collection_form_id, x_amzn_shipping_business_id: nil, rate_limit: 80.0)
        cannot_sandbox!

        path = "/shipping/v2/collectionForms/#{collection_form_id}"

        meter(rate_limit).get(path)
      end

      # Returns a list of access points in proximity of input postal code.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param access_point_types [Array<String>]
      # @param country_code [String]
      # @param postal_code [String]
      # @param x_amzn_shipping_business_id [String] Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_access_points(access_point_types, country_code, postal_code, x_amzn_shipping_business_id: nil,
        rate_limit: 80.0)
        path = "/shipping/v2/accessPoints"
        params = {
          "accessPointTypes" => access_point_types,
          "countryCode" => country_code,
          "postalCode" => postal_code,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
