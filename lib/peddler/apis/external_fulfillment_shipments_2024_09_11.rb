# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Amazon External Fulfillment Shipments Processing
    #
    # You can use the External Fulfillment Shipments API to retrieve, manage, and track shipments processed through
    # Amazon's external fulfillment network. Use this API to get shipment details, monitor status changes, and access
    # fulfillment requirements.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentShipments_2024-09-11.json
    class ExternalFulfillmentShipments20240911 < API
      # Get a list of shipments created for the seller in the status you specify. Shipments can be further filtered
      # based on the fulfillment node or the time of the shipments' last update.
      #
      # @note This operation can make a static sandbox call.
      # @param location_id [String] The Amazon channel location identifier for the shipments you want to retrieve.
      # @param marketplace_id [String] The marketplace ID associated with the location. To find the ID for your
      #   marketplace, refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param channel_name [String] The channel name associated with the location.
      # @param status [String] The status of shipment you want to include in the response. To retrieve all new
      #   shipments, set this value to `ACCEPTED`.
      # @param last_updated_after [String] The response includes shipments whose latest update is after the specified
      #   time. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param last_updated_before [String] The response includes shipments whose latest update is before the specified
      #   time. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param max_results [Integer] The maximum number of shipments to include in the response.
      # @param pagination_token [String] A token that you use to retrieve the next page of results. The response
      #   includes `nextToken` when there are multiple pages of results. To get the next page of results, call the
      #   operation with this token and include the same arguments as the call that produced the token. To get a
      #   complete list, call this operation until `nextToken` is null. Note that this operation can return empty pages.
      # @return [Peddler::Response] The API response
      def get_shipments(status, location_id: nil, marketplace_id: nil, channel_name: nil, last_updated_after: nil,
        last_updated_before: nil, max_results: nil, pagination_token: nil)
        path = "/externalFulfillment/2024-09-11/shipments"
        params = {
          "locationId" => location_id,
          "marketplaceId" => marketplace_id,
          "channelName" => channel_name,
          "status" => status,
          "lastUpdatedAfter" => last_updated_after,
          "lastUpdatedBefore" => last_updated_before,
          "maxResults" => max_results,
          "paginationToken" => pagination_token,
        }.compact
        parser = -> { ShipmentsResponse }
        get(path, params:, parser:)
      end

      # Get a single shipment with the ID you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment you want to retrieve.
      # @return [Peddler::Response] The API response
      def get_shipment(shipment_id)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}"
        parser = -> { Shipment }
        get(path, parser:)
      end

      # Confirm or reject the specified shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment you want to confirm or reject.
      # @param operation [String] The status of the shipment.
      # @param body [Hash] Information about the shipment and its line items.
      # @return [Peddler::Response] The API response
      def process_shipment(shipment_id, operation, body: nil)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}"
        params = {
          "operation" => operation,
        }.compact
        post(path, body:, params:)
      end

      # Provide details about the packages in the specified shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment.
      # @param body [Hash] A list of packages in the shipment.
      # @return [Peddler::Response] The API response
      def create_packages(shipment_id, body)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/packages"
        post(path, body:)
      end

      # Updates the details about the packages that will be used to fulfill the specified shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment to which the package belongs.
      # @param package_id [String] The ID of the package whose information you want to update.
      # @param body [Hash] The body of the request.
      # @return [Peddler::Response] The API response
      def update_package(shipment_id, package_id, body)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/packages/#{percent_encode(package_id)}"
        put(path, body:)
      end

      # Updates the status of the packages.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment to which the package belongs.
      # @param package_id [String] The ID of the package whose status you want to update.
      # @param status [String] **DEPRECATED**. Do not use. Package status is defined in the body parameter.
      # @param body [Hash] The body of the request.
      # @return [Peddler::Response] The API response
      def update_package_status(shipment_id, package_id, status: nil, body: nil)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/packages/#{percent_encode(package_id)}"
        params = {
          "status" => status,
        }.compact
        patch(path, body:, params:)
      end

      # Get a list of shipping options for a package in a shipment given the shipment's marketplace and channel. If the
      # marketplace and channel have a pre-determined shipping option, then this operation returns an empty response.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment to which the package belongs.
      # @param package_id [String] The ID of the package for which you want to retrieve shipping options.
      # @return [Peddler::Response] The API response
      def retrieve_shipping_options(shipment_id, package_id)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/shippingOptions"
        params = {
          "packageId" => package_id,
        }.compact
        parser = -> { ShippingOptionsResponse }
        get(path, params:, parser:)
      end

      # Get invoices for the shipment you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment whose invoice you want.
      # @return [Peddler::Response] The API response
      def generate_invoice(shipment_id)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/invoice"
        parser = -> { InvoiceResponse }
        post(path, parser:)
      end

      # Retrieve invoices for the shipment you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment whose invoice you want to retrieve.
      # @return [Peddler::Response] The API response
      def retrieve_invoice(shipment_id)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/invoice"
        parser = -> { InvoiceResponse }
        get(path, parser:)
      end

      # Generate and retrieve all shipping labels for one or more packages in the shipment you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The ID of the shipment whose shipping labels you want to generate and retrieve.
      # @param shipping_option_id [String] The ID of the shipping option whose shipping labels you want.
      # @param operation [String] Specify whether you want to generate or regenerate a label.
      # @param body [Hash] Shipping details for when shipping is not done by the marketplace channel.
      # @return [Peddler::Response] The API response
      def generate_ship_labels(shipment_id, operation, shipping_option_id: nil, body: nil)
        path = "/externalFulfillment/2024-09-11/shipments/#{percent_encode(shipment_id)}/shipLabels"
        params = {
          "shippingOptionId" => shipping_option_id,
          "operation" => operation,
        }.compact
        parser = -> { ShipLabelsResponse }
        put(path, body:, params:, parser:)
      end
    end
  end
end
