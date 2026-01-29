# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Shipments
    #
    # The Selling Partner API for Retail Procurement Shipments provides programmatic access to retail shipping data for
    # vendors.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-shipments-api-model/vendorShipments.json
    class VendorShipmentsV1 < API
      # Submits one or more shipment confirmations for vendor orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] A request to submit shipment confirmation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipment_confirmations(body, rate_limit: 10.0)
        path = "/vendor/shipping/v1/shipmentConfirmations"
        parser = -> { SubmitShipmentConfirmationsResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Submits one shipment confirmation for vendor orders and get response immediately.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] A request to submit shipment confirmation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipment_confirmation(body, rate_limit: 10.0)
        path = "/vendor/shipping/v1/shipmentConfirmation"
        parser = -> { SubmitShipmentConfirmationResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Submits one or more shipment request for vendor Orders.
      #
      # @param body [Hash] A request to submit shipment request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipments(body, rate_limit: 10.0)
        cannot_sandbox!

        path = "/vendor/shipping/v1/shipments"
        parser = -> { SubmitShipmentConfirmationsResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Returns the Details about Shipment, Carrier Details, status of the shipment, container details and other details
      # related to shipment based on the filter parameters value that you specify.
      #
      # @param limit [Integer] The limit to the number of records returned. Default value is 50 records.
      # @param sort_order [String] Sort in ascending or descending order by purchase order creation date.
      # @param next_token [String] Used for pagination when there are more shipments than the specified result size
      #   limit.
      # @param created_after [String] Get Shipment Details that became available after this timestamp will be included
      #   in the result. Must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param created_before [String] Get Shipment Details that became available before this timestamp will be included
      #   in the result. Must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param shipment_confirmed_before [String] Get Shipment Details by passing Shipment confirmed create Date Before.
      #   Must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param shipment_confirmed_after [String] Get Shipment Details by passing Shipment confirmed create Date After.
      #   Must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param package_label_created_before [String] Get Shipment Details by passing Package label create Date by buyer.
      #   Must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param package_label_created_after [String] Get Shipment Details by passing Package label create Date After by
      #   buyer. Must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param shipped_before [String] Get Shipment Details by passing Shipped Date Before. Must be in
      #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param shipped_after [String] Get Shipment Details by passing Shipped Date After. Must be in
      #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param estimated_delivery_before [String] Get Shipment Details by passing Estimated Delivery Date Before. Must
      #   be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param estimated_delivery_after [String] Get Shipment Details by passing Estimated Delivery Date After. Must be
      #   in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param shipment_delivery_before [String] Get Shipment Details by passing Shipment Delivery Date Before. Must be
      #   in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param shipment_delivery_after [String] Get Shipment Details by passing Shipment Delivery Date After. Must be in
      #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param requested_pick_up_before [String] Get Shipment Details by passing Before Requested pickup date. Must be
      #   in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param requested_pick_up_after [String] Get Shipment Details by passing After Requested pickup date. Must be in
      #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param scheduled_pick_up_before [String] Get Shipment Details by passing Before scheduled pickup date. Must be
      #   in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param scheduled_pick_up_after [String] Get Shipment Details by passing After Scheduled pickup date. Must be in
      #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param current_shipment_status [String] Get Shipment Details by passing Current shipment status.
      # @param vendor_shipment_identifier [String] Get Shipment Details by passing Vendor Shipment ID
      # @param buyer_reference_number [String] Get Shipment Details by passing buyer Reference ID
      # @param buyer_warehouse_code [String] Get Shipping Details based on buyer warehouse code. This value should be
      #   same as 'shipToParty.partyId' in the Shipment.
      # @param seller_warehouse_code [String] Get Shipping Details based on vendor warehouse code. This value should be
      #   same as 'sellingParty.partyId' in the Shipment.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment_details(limit: nil, sort_order: nil, next_token: nil, created_after: nil, created_before: nil,
        shipment_confirmed_before: nil, shipment_confirmed_after: nil, package_label_created_before: nil,
        package_label_created_after: nil, shipped_before: nil, shipped_after: nil, estimated_delivery_before: nil,
        estimated_delivery_after: nil, shipment_delivery_before: nil, shipment_delivery_after: nil,
        requested_pick_up_before: nil, requested_pick_up_after: nil, scheduled_pick_up_before: nil,
        scheduled_pick_up_after: nil, current_shipment_status: nil, vendor_shipment_identifier: nil,
        buyer_reference_number: nil, buyer_warehouse_code: nil, seller_warehouse_code: nil, rate_limit: 10.0)
        cannot_sandbox!

        path = "/vendor/shipping/v1/shipments"
        params = {
          "limit" => limit,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "shipmentConfirmedBefore" => shipment_confirmed_before,
          "shipmentConfirmedAfter" => shipment_confirmed_after,
          "packageLabelCreatedBefore" => package_label_created_before,
          "packageLabelCreatedAfter" => package_label_created_after,
          "shippedBefore" => shipped_before,
          "shippedAfter" => shipped_after,
          "estimatedDeliveryBefore" => estimated_delivery_before,
          "estimatedDeliveryAfter" => estimated_delivery_after,
          "shipmentDeliveryBefore" => shipment_delivery_before,
          "shipmentDeliveryAfter" => shipment_delivery_after,
          "requestedPickUpBefore" => requested_pick_up_before,
          "requestedPickUpAfter" => requested_pick_up_after,
          "scheduledPickUpBefore" => scheduled_pick_up_before,
          "scheduledPickUpAfter" => scheduled_pick_up_after,
          "currentShipmentStatus" => current_shipment_status,
          "vendorShipmentIdentifier" => vendor_shipment_identifier,
          "buyerReferenceNumber" => buyer_reference_number,
          "buyerWarehouseCode" => buyer_warehouse_code,
          "sellerWarehouseCode" => seller_warehouse_code,
        }.compact
        parser = -> { GetShipmentDetailsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns small parcel shipment labels based on the filters that you specify.
      #
      # @param limit [Integer] The limit to the number of records returned. Default value is 50 records.
      # @param sort_order [String] Sort the list by shipment label creation date in ascending or descending order.
      # @param next_token [String] A token that you use to retrieve the next page of results. The response includes
      #   `nextToken` when the number of results exceeds the specified `pageSize` value. To get the next page of
      #   results, call the operation with this token and include the same arguments as the call that produced the
      #   token. To get a complete list, call this operation until `nextToken` is null. Note that this operation can
      #   return empty pages.
      # @param label_created_after [String] Shipment labels created after this time will be included in the result. This
      #   field must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format.
      # @param label_created_before [String] Shipment labels created before this time will be included in the result.
      #   This field must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format.
      # @param buyer_reference_number [String] Get Shipment labels by passing buyer reference number.
      # @param vendor_shipment_identifier [String] Get Shipment labels by passing vendor shipment identifier.
      # @param seller_warehouse_code [String] Get Shipping labels based on vendor warehouse code. This value must be
      #   same as the `sellingParty.partyId` in the shipment.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment_labels(limit: nil, sort_order: nil, next_token: nil, label_created_after: nil,
        label_created_before: nil, buyer_reference_number: nil, vendor_shipment_identifier: nil,
        seller_warehouse_code: nil, rate_limit: 10.0)
        cannot_sandbox!

        path = "/vendor/shipping/v1/transportLabels"
        params = {
          "limit" => limit,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
          "labelCreatedAfter" => label_created_after,
          "labelCreatedBefore" => label_created_before,
          "buyerReferenceNumber" => buyer_reference_number,
          "vendorShipmentIdentifier" => vendor_shipment_identifier,
          "sellerWarehouseCode" => seller_warehouse_code,
        }.compact
        parser = -> { GetShipmentLabels }
        get(path, params:, rate_limit:, parser:)
      end
    end
  end
end
