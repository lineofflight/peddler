# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def fulfillment_inbound_2024_03_20(...)
      APIs::FulfillmentInbound20240320.new(...)
    end
  end

  module APIs
    # The Selling Partner API for FBA inbound operations.
    #
    # The Selling Partner API for Fulfillment By Amazon (FBA) Inbound. The FBA Inbound API enables building inbound
    # workflows to create, manage, and send shipments into Amazon's fulfillment network. The API has interoperability
    # with the Send-to-Amazon user interface.
    class FulfillmentInbound20240320 < API
      # Provides a list of inbound plans with minimal information.
      #
      # @note This operation can make a static sandbox call.
      # @param page_size [Integer] The number of inbound plans to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param status [String] The status of an inbound plan.
      # @param sort_by [String] Sort by field.
      # @param sort_order [String] The sort order.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_inbound_plans(page_size: 10, pagination_token: nil, status: nil, sort_by: nil, sort_order: nil,
        rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
          "status" => status,
          "sortBy" => sort_by,
          "sortOrder" => sort_order,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Creates an inbound plan. An inbound plan contains all the necessary information to send shipments into Amazon's
      # fufillment network.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The body of the request to `createInboundPlan`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_inbound_plan(body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans"

        meter(rate_limit).post(path, body:)
      end

      # Fetches the top level information about an inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_inbound_plan(inbound_plan_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}"

        meter(rate_limit).get(path)
      end

      # Provides a paginated list of box packages in an inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param page_size [Integer] The number of boxes to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_inbound_plan_boxes(inbound_plan_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/boxes"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Cancels an Inbound Plan. Charges may apply if the cancellation is performed outside of a void window. The window
      # for Amazon Partnered Carriers is 24 hours for Small Parcel Delivery (SPD) and one hour for Less-Than-Truckload
      # (LTL) carrier shipments.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_inbound_plan(inbound_plan_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/cancellation"

        meter(rate_limit).put(path)
      end

      # Provides a paginated list of item packages in an inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param page_size [Integer] The number of items to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_inbound_plan_items(inbound_plan_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/items"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Updates the name of an existing inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param body [Hash] The body of the request to `updateInboundPlanName`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_inbound_plan_name(inbound_plan_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/name"

        meter(rate_limit).put(path, body:)
      end

      # Retrieves a page of boxes from a given packing group. These boxes were previously provided through the
      # `setPackingInformation` operation. This API is used for workflows where boxes are packed before Amazon
      # determines shipment splits.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param packing_group_id [String] Identifier of a packing group.
      # @param page_size [Integer] The number of packing group boxes to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_packing_group_boxes(inbound_plan_id, packing_group_id, page_size: 10, pagination_token: nil,
        rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/packingGroups/#{percent_encode(packing_group_id)}/boxes"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Retrieves a page of items in a given packing group. Packing options must first be generated by the corresponding
      # operation before packing group items can be listed.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param packing_group_id [String] Identifier of a packing group.
      # @param page_size [Integer] The number of packing group items to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_packing_group_items(inbound_plan_id, packing_group_id, page_size: 10, pagination_token: nil,
        rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/packingGroups/#{percent_encode(packing_group_id)}/items"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Sets packing information for an inbound plan. This should be called after an inbound plan is created to populate
      # the box level information required for planning and transportation estimates.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param body [Hash] The body of the request to `setPackingInformation`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def set_packing_information(inbound_plan_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/packingInformation"

        meter(rate_limit).post(path, body:)
      end

      # Retrieves a list of all packing options for an inbound plan. Packing options must first be generated by the
      # corresponding operation before becoming available.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param page_size [Integer] The number of packing options to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_packing_options(inbound_plan_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/packingOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Generates available packing options for the inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_packing_options(inbound_plan_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/packingOptions"

        meter(rate_limit).post(path)
      end

      # Confirms the packing option for an inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param packing_option_id [String] Identifier of a packing option.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_packing_option(inbound_plan_id, packing_option_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/packingOptions/#{percent_encode(packing_option_id)}/confirmation"

        meter(rate_limit).post(path)
      end

      # Provides a paginated list of pallet packages in an inbound plan. An inbound plan will have pallets when the
      # related details are provided after generating Less-Than-Truckload (LTL) carrier shipments.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param page_size [Integer] The number of pallets to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_inbound_plan_pallets(inbound_plan_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/pallets"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Provides a list of all placement options for an inbound plan. Placement options must first be generated by the
      # corresponding operation before becoming available.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param page_size [Integer] The number of placement options to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_placement_options(inbound_plan_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/placementOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Generates placement options for the inbound plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param body [Hash] The body of the request to `generatePlacementOptions`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_placement_options(inbound_plan_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/placementOptions"

        meter(rate_limit).post(path, body:)
      end

      # Confirms the placement option for an inbound plan. Once confirmed, it cannot be changed for the Inbound Plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param placement_option_id [String] The identifier of a placement option. A placement option represents the
      #   shipment splits and destinations of SKUs.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_placement_option(inbound_plan_id, placement_option_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/placementOptions/#{percent_encode(placement_option_id)}/confirmation"

        meter(rate_limit).post(path)
      end

      # Provides the full details for a specific shipment within an inbound plan. The `transportationOptionId` inside
      # `acceptedTransportationSelection` can be used to retrieve the transportation details for the shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment(inbound_plan_id, shipment_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}"

        meter(rate_limit).get(path)
      end

      # Update/Add custom identifier to the boxes within a shipment. These custom identifiers are provided by the
      # clients and reflected on the box labels to identify boxes. One example of this custom identifier is the SSCC
      # (Serial Shipping Container Codes) barcodes, with the encoding of GS1-128, which is an industry standard to
      # uniquely identify boxes.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier to an inbound plan.
      # @param shipment_id [String] Identifier to a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `updateBoxIdentifiers`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_box_identifiers(inbound_plan_id, shipment_id, body, rate_limit: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/boxIdentifiers"

        meter(rate_limit).put(path, body:)
      end

      # Provides a paginated list of box packages in a shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param page_size [Integer] The number of boxes to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_shipment_boxes(inbound_plan_id, shipment_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/boxes"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Retrieve a paginated list of shipment content update previews for a given shipment. The shipment content update
      # preview is a summary of the requested shipment content changes along with the transportation cost implications
      # of the change that can only be confirmed prior to the expiry date specified.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param page_size [Integer] The number of content update previews to return.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_shipment_content_update_previews(inbound_plan_id, shipment_id, page_size: 10, pagination_token: nil,
        rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/contentUpdatePreviews"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Generate a shipment content update preview given a set of intended boxes and/or items for a shipment with a
      # confirmed carrier. The shipment content update preview will be viewable with the updated costs and contents
      # prior to confirmation.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `generateShipmentContentUpdatePreviews`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_shipment_content_update_previews(inbound_plan_id, shipment_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/contentUpdatePreviews"

        meter(rate_limit).post(path, body:)
      end

      # Retrieve a shipment content update preview which provides a summary of the requested shipment content changes
      # along with the transportation cost implications of the change that can only be confirmed prior to the expiry
      # date specified.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param content_update_preview_id [String] Identifier of a content update preview.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment_content_update_preview(inbound_plan_id, shipment_id, content_update_preview_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/contentUpdatePreviews/#{percent_encode(content_update_preview_id)}"

        meter(rate_limit).get(path)
      end

      # Confirm a shipment content update preview and accept the changes in transportation cost.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param content_update_preview_id [String] Identifier of a content update preview.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_shipment_content_update_preview(inbound_plan_id, shipment_id, content_update_preview_id,
        rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/contentUpdatePreviews/#{percent_encode(content_update_preview_id)}/confirmation"

        meter(rate_limit).post(path)
      end

      # Provide delivery challan document for PCP transportation in IN marketplace.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_delivery_challan_document(inbound_plan_id, shipment_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/deliveryChallanDocument"

        meter(rate_limit).get(path)
      end

      # Retrieves all delivery window options for a shipment. Delivery window options must first be generated by the
      # `generateDeliveryWindowOptions` operation before becoming available.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] The shipment to get delivery window options for.
      # @param page_size [Integer] The number of delivery window options to return in the response matching the given
      #   query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_delivery_window_options(inbound_plan_id, shipment_id, page_size: 10, pagination_token: nil,
        rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/deliveryWindowOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Generates available delivery window options for a given shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] The shipment to generate delivery window options for.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_delivery_window_options(inbound_plan_id, shipment_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/deliveryWindowOptions"

        meter(rate_limit).post(path)
      end

      # Confirms the delivery window option for chosen shipment within an inbound plan. A placement option must be
      # confirmed prior to use of this API. Once confirmed, new delivery window options cannot be generated, but the
      # chosen delivery window option can be updated before shipment closure. The window is used to provide the expected
      # time when a shipment will arrive at the warehouse. All transportation options which have the program
      # `CONFIRMED_DELIVERY_WINDOW` require a delivery window to be confirmed prior to transportation option
      # confirmation.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] The shipment to confirm the delivery window option for.
      # @param delivery_window_option_id [String] The id of the delivery window option to be confirmed.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_delivery_window_options(inbound_plan_id, shipment_id, delivery_window_option_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/deliveryWindowOptions/#{percent_encode(delivery_window_option_id)}/confirmation"

        meter(rate_limit).post(path)
      end

      # Provides a paginated list of item packages in a shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param page_size [Integer] The number of items to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_shipment_items(inbound_plan_id, shipment_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/items"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Updates the name of an existing shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `updateShipmentName`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_shipment_name(inbound_plan_id, shipment_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/name"

        meter(rate_limit).put(path, body:)
      end

      # Provides a paginated list of pallet packages in a shipment. A palletized shipment will have pallets when the
      # related details are provided after generating Less-Than-Truckload (LTL) carrier shipments.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param page_size [Integer] The number of pallets to return in the response matching the given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_shipment_pallets(inbound_plan_id, shipment_id, page_size: 10, pagination_token: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/pallets"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Cancels a self-ship appointment slot against a shipment. Only available in the following
      # [marketplaces](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids): MX, BR, EG, SA, AE, IN.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `cancelSelfShipAppointment`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_self_ship_appointment(inbound_plan_id, shipment_id, body, rate_limit: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/selfShipAppointmentCancellation"

        meter(rate_limit).put(path, body:)
      end

      # Retrieves a list of available self-ship appointment slots used to drop off a shipment at a warehouse. Only
      # available in the following [marketplaces](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids): MX,
      # BR, EG, SA, AE, IN.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param page_size [Integer] The number of self ship appointment slots to return in the response matching the
      #   given query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_self_ship_appointment_slots(inbound_plan_id, shipment_id, page_size: 10, pagination_token: nil,
        rate_limit: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/selfShipAppointmentSlots"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Initiates the process of generating the appointment slots list. Only available in the following
      # [marketplaces](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids): MX, BR, EG, SA, AE, IN.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `generateSelfShipAppointmentSlots`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_self_ship_appointment_slots(inbound_plan_id, shipment_id, body, rate_limit: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/selfShipAppointmentSlots"

        meter(rate_limit).post(path, body:)
      end

      # Confirms or reschedules a self-ship appointment slot against a shipment. Only available in the following
      # [marketplaces](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids): MX, BR, EG, SA, AE, IN.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param slot_id [String] An identifier to a self-ship appointment slot.
      # @param body [Hash] The body of the request to `scheduleSelfShipAppointment`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def schedule_self_ship_appointment(inbound_plan_id, shipment_id, slot_id, body, rate_limit: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/selfShipAppointmentSlots/#{percent_encode(slot_id)}/schedule"

        meter(rate_limit).post(path, body:)
      end

      # Updates the source address of an existing shipment. The shipment source address can only be updated prior to the
      # confirmation of the shipment carriers. As a result of the updated source address, existing transportation
      # options will be invalidated and will need to be regenerated to capture the potential difference in
      # transportation options and quotes due to the new source address.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `updateShipmentSourceAddress`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_shipment_source_address(inbound_plan_id, shipment_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/sourceAddress"

        meter(rate_limit).put(path, body:)
      end

      # Updates a shipment's tracking details.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param shipment_id [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param body [Hash] The body of the request to `updateShipmentTrackingDetails`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_shipment_tracking_details(inbound_plan_id, shipment_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/shipments/#{percent_encode(shipment_id)}/trackingDetails"

        meter(rate_limit).put(path, body:)
      end

      # Retrieves all transportation options for a shipment. Transportation options must first be generated by the
      # `generateTransportationOptions` operation before becoming available.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param page_size [Integer] The number of transportation options to return in the response matching the given
      #   query.
      # @param pagination_token [String] A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param placement_option_id [String] The placement option to get transportation options for. Either
      #   `placementOptionId` or `shipmentId` must be specified.
      # @param shipment_id [String] The shipment to get transportation options for. Either `placementOptionId` or
      #   `shipmentId` must be specified.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_transportation_options(inbound_plan_id, page_size: 10, pagination_token: nil, placement_option_id: nil,
        shipment_id: nil, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/transportationOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
          "placementOptionId" => placement_option_id,
          "shipmentId" => shipment_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Generates available transportation options for a given placement option.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param body [Hash] The body of the request to `generateTransportationOptions`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_transportation_options(inbound_plan_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/transportationOptions"

        meter(rate_limit).post(path, body:)
      end

      # Confirms all the transportation options for an inbound plan. A placement option must be confirmed prior to use
      # of this API. Once confirmed, new transportation options can not be generated or confirmed for the Inbound Plan.
      #
      # @note This operation can make a static sandbox call.
      # @param inbound_plan_id [String] Identifier of an inbound plan.
      # @param body [Hash] The body of the request to `confirmTransportationOptions`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_transportation_options(inbound_plan_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{percent_encode(inbound_plan_id)}/transportationOptions/confirmation"

        meter(rate_limit).post(path, body:)
      end

      # List the inbound compliance details for MSKUs in a given marketplace.
      #
      # **Note:** MSKUs that contain certain characters must be encoded. For more information, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # The following characters must be double percent encoded:
      #
      # - `%`
      # - `+`
      # - `,`
      #
      # **Examples:** An MSKU value of `test%msku` is encoded as `test%2525msku`. An MSKU value of `test,msku` is
      # encoded as `test%252Cmsku`.
      #
      # @note This operation can make a static sandbox call.
      # @param mskus [Array<String>] A list of merchant SKUs, a merchant-supplied identifier of a specific SKU.
      # @param marketplace_id [String] The Marketplace ID. For a list of possible values, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_item_compliance_details(mskus, marketplace_id, rate_limit: nil)
        path = "/inbound/fba/2024-03-20/items/compliance"
        params = {
          "mskus" => stringify_array(mskus),
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Update compliance details for a list of MSKUs. The details provided here are only used for the India (IN -
      # A21TJRUUN4KGV) marketplace compliance validation.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The Marketplace ID. For a list of possible values, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param body [Hash] The body of the request to `updateItemComplianceDetails`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_item_compliance_details(marketplace_id, body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/items/compliance"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).put(path, body:, params:)
      end

      # For a given marketplace - creates labels for a list of MSKUs.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The body of the request to `createMarketplaceItemLabels`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_marketplace_item_labels(body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/items/labels"

        meter(rate_limit).post(path, body:)
      end

      # Get preparation details for a list of MSKUs in a specified marketplace.
      #
      # **Note:** MSKUs that contain certain characters must be encoded. For more information, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # The following characters must be double percent encoded:
      #
      # - `%`
      # - `+`
      # - `,`
      #
      # **Examples:** An MSKU value of `test%msku` is encoded as `test%2525msku`. An MSKU value of `test,msku` is
      # encoded as `test%252Cmsku`.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The marketplace ID. For a list of possible values, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param mskus [Array<String>] A list of merchant SKUs, a merchant-supplied identifier of a specific SKU.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_prep_details(marketplace_id, mskus, rate_limit: nil)
        path = "/inbound/fba/2024-03-20/items/prepDetails"
        params = {
          "marketplaceId" => marketplace_id,
          "mskus" => stringify_array(mskus),
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Set the preparation details for a list of MSKUs in a specified marketplace.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The body of the request to `setPrepDetails`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def set_prep_details(body, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/items/prepDetails"

        meter(rate_limit).post(path, body:)
      end

      # Gets the status of the processing of an asynchronous API call.
      #
      # @note This operation can make a static sandbox call.
      # @param operation_id [String] Identifier of an asynchronous operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_inbound_operation_status(operation_id, rate_limit: 2.0)
        path = "/inbound/fba/2024-03-20/operations/#{percent_encode(operation_id)}"

        meter(rate_limit).get(path)
      end
    end
  end
end
