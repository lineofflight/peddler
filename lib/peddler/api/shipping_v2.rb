# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Amazon Shipping API
    #
    # The Amazon Shipping API is designed to support outbound shipping use cases both for orders originating on
    # Amazon-owned marketplaces as well as external channels/marketplaces. With these APIs, you can request shipping
    # rates, create shipments, cancel shipments, and track shipments.
    class ShippingV2 < API
      # Returns the available shipping service offerings.
      #
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_rates(body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/shipments/rates"
        body = body

        rate_limit(80.0).post(path, body:)
      end

      # Purchases the shipping service for a shipment using the best fit service offering. Returns purchase related
      # details and documents.
      #
      # @param [Hash] body
      # @param [String] x_amzn_idempotency_key A unique value which the server uses to recognize subsequent retries of
      #   the same request.
      # @param [String] locale The IETF Language Tag. Note that this only supports the primary language subtag with one
      #   secondary language subtag (i.e. en-US, fr-CA). The secondary language subtag is almost always a regional
      #   designation. This does not support additional subtags beyond the primary and secondary language subtags.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def direct_purchase_shipment(body, x_amzn_idempotency_key: nil, locale: nil, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/shipments/directPurchase"
        body = body

        rate_limit(80.0).post(path, body:)
      end

      # Purchases a shipping service and returns purchase related details and documents. Note: You must complete the
      # purchase within 10 minutes of rate creation by the shipping service provider. If you make the request after the
      # 10 minutes have expired, you will receive an error response with the error code equal to "TOKEN_EXPIRED". If you
      # receive this error response, you must get the rates for the shipment again.
      #
      # @param [Hash] body
      # @param [String] x_amzn_idempotency_key A unique value which the server uses to recognize subsequent retries of
      #   the same request.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def purchase_shipment(body, x_amzn_idempotency_key: nil, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/shipments"
        body = body

        rate_limit(80.0).post(path, body:)
      end

      # Purchases a shipping service identifier and returns purchase-related details and documents.
      #
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def one_click_shipment(body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/oneClickShipment"
        body = body

        rate_limit(80.0).post(path, body:)
      end

      # Returns tracking information for a purchased shipment.
      #
      # @param [String] tracking_id A carrier-generated tracking identifier originally returned by the purchaseShipment
      #   operation.
      # @param [String] carrier_id A carrier identifier originally returned by the getRates operation for the selected
      #   rate.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_tracking(tracking_id, carrier_id, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/tracking"
        params = {
          "trackingId" => tracking_id,
          "carrierId" => carrier_id,
        }.compact

        rate_limit(80.0).get(path, params:)
      end

      # Returns the shipping documents associated with a package in a shipment.
      #
      # @param [String] shipment_id The shipment identifier originally returned by the purchaseShipment operation.
      # @param [String] package_client_reference_id The package client reference identifier originally provided in the
      #   request body parameter for the getRates operation.
      # @param [String] format The file format of the document. Must be one of the supported formats returned by the
      #   getRates operation.
      # @param [Number] dpi The resolution of the document (for example, 300 means 300 dots per inch). Must be one of
      #   the supported resolutions returned in the response to the getRates operation.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_shipment_documents(shipment_id, package_client_reference_id, format: nil, dpi: nil,
        x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/shipments/#{shipment_id}/documents"
        params = {
          "packageClientReferenceId" => package_client_reference_id,
          "format" => format,
          "dpi" => dpi,
        }.compact

        rate_limit(80.0).get(path, params:)
      end

      # Cancels a purchased shipment. Returns an empty object if the shipment is successfully cancelled.
      #
      # @param [String] shipment_id The shipment identifier originally returned by the purchaseShipment operation.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def cancel_shipment(shipment_id, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/shipments/#{shipment_id}/cancel"

        rate_limit(80.0).put(path)
      end

      # Returns the JSON schema to use for providing additional inputs when needed to purchase a shipping offering. Call
      # the getAdditionalInputs operation when the response to a previous call to the getRates operation indicates that
      # additional inputs are required for the rate (shipping offering) that you want to purchase.
      #
      # @param [String] request_token The request token returned in the response to the getRates operation.
      # @param [String] rate_id The rate identifier for the shipping offering (rate) returned in the response to the
      #   getRates operation.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_additional_inputs(request_token, rate_id, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/shipments/additionalInputs/schema"
        params = {
          "requestToken" => request_token,
          "rateId" => rate_id,
        }.compact

        rate_limit(80.0).get(path, params:)
      end

      # This API will return a list of input schema required to register a shipper account with the carrier.
      #
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_carrier_account_form_inputs(x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/carrierAccountFormInputs"

        rate_limit(80.0).get(path)
      end

      # This API will return Get all carrier accounts for a merchant.
      #
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_carrier_accounts(body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/carrierAccounts"
        body = body

        rate_limit(80.0).put(path, body:)
      end

      # This API associates/links the specified carrier account with the merchant.
      #
      # @param [String] carrier_id The unique identifier associated with the carrier account.
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def link_carrier_account(carrier_id, body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/carrierAccounts/#{carrier_id}"
        body = body

        rate_limit(80.0).put(path, body:)
      end

      # This API Unlink the specified carrier account with the merchant.
      #
      # @param [String] carrier_id carrier Id to unlink with merchant.
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def unlink_carrier_account(carrier_id, body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/carrierAccounts/#{carrier_id}/unlink"
        body = body

        rate_limit(80.0).put(path, body:)
      end

      # This API Call to generate the collection form.
      #
      # @param [Hash] body
      # @param [String] x_amzn_idempotency_key A unique value which the server uses to recognize subsequent retries of
      #   the same request.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def generate_collection_form(body, x_amzn_idempotency_key: nil, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/collectionForms"
        body = body

        rate_limit(80.0).post(path, body:)
      end

      # This API Call to get the history of the previously generated collection forms.
      #
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_collection_form_history(body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/collectionForms/history"
        body = body

        rate_limit(80.0).put(path, body:)
      end

      # This API Get all unmanifested carriers with shipment locations. Any locations which has unmanifested shipments
      # with an eligible carrier for manifesting shall be returned.
      #
      # @param [Hash] body
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_unmanifested_shipments(body, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/unmanifestedShipments"
        body = body

        rate_limit(80.0).put(path, body:)
      end

      # This API reprint a collection form.
      #
      # @param [String] collection_form_id collection form Id to reprint a collection.
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_collection_form(collection_form_id, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/collectionForms/#{collection_form_id}"

        rate_limit(80.0).get(path)
      end

      # Returns a list of access points in proximity of input postal code.
      #
      # @param [Array<String>] access_point_types
      # @param [String] country_code
      # @param [String] postal_code
      # @param [String] x_amzn_shipping_business_id Amazon shipping business to assume for this request. The default is
      #   AmazonShipping_UK.
      # @return [Hash] The API response
      def get_access_points(access_point_types, country_code, postal_code, x_amzn_shipping_business_id: nil)
        path = "/shipping/v2/accessPoints"
        params = {
          "accessPointTypes" => access_point_types,
          "countryCode" => country_code,
          "postalCode" => postal_code,
        }.compact

        rate_limit(80.0).get(path, params:)
      end
    end
  end
end
