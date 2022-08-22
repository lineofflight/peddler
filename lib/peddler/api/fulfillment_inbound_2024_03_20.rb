# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # The Selling Partner API for FBA inbound operations.
    #
    # The Selling Partner API for Fulfillment By Amazon (FBA) Inbound. The FBA Inbound API enables building inbound
    # workflows to create, manage, and send shipments into Amazon's fulfillment network. The API has interoperability
    # with the Send-to-Amazon user interface.
    class FulfillmentInbound20240320 < API
      # Provides a list of inbound plans with minimal information.
      #
      # @param [Integer] page_size The number of inbound plans to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param [String] status The status of an inbound plan.
      # @param [String] sort_by Sort by field.
      # @param [String] sort_order The sort order.
      # @return [Hash] The API response
      def list_inbound_plans(page_size: nil, pagination_token: nil, status: nil, sort_by: nil, sort_order: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
          "status" => status,
          "sortBy" => sort_by,
          "sortOrder" => sort_order,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Creates an inbound plan. An inbound plan contains all the necessary information to send shipments into Amazon's
      # fufillment network.
      #
      # @param [Hash] body The body of the request to `createInboundPlan`.
      # @return [Hash] The API response
      def create_inbound_plan(body)
        path = "/inbound/fba/2024-03-20/inboundPlans"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Fetches the top level information about an inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @return [Hash] The API response
      def get_inbound_plan(inbound_plan_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}"

        retriable(delay: proc { |i| 2.0 * i }).get(path)
      end

      # Provides a paginated list of box packages in an inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Integer] page_size The number of boxes to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_inbound_plan_boxes(inbound_plan_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/boxes"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Cancels an Inbound Plan. Charges may apply if the cancellation is performed outside of a void window. The window
      # for Amazon Partnered Carriers is 24 hours for Small Parcel Delivery (SPD) and one hour for Less-Than-Truckload
      # (LTL) carrier shipments.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @return [Hash] The API response
      def cancel_inbound_plan(inbound_plan_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/cancellation"

        retriable(delay: proc { |i| 2.0 * i }).put(path)
      end

      # Provides a paginated list of item packages in an inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Integer] page_size The number of items to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_inbound_plan_items(inbound_plan_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/items"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Updates the name of an existing inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Hash] body The body of the request to `updateInboundPlanName`.
      # @return [Hash] The API response
      def update_inbound_plan_name(inbound_plan_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/name"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).put(path, body:)
      end

      # Retrieves a page of boxes from a given packing group. These boxes were previously provided through the
      # `setPackingInformation` operation. This API is used for workflows where boxes are packed before Amazon
      # determines shipment splits.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] packing_group_id Identifier of a packing group.
      # @param [Integer] page_size The number of packing group boxes to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_packing_group_boxes(inbound_plan_id, packing_group_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/packingGroups/#{packing_group_id}/boxes"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Retrieves a page of items in a given packing group. Packing options must first be generated by the corresponding
      # operation before packing group items can be listed.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] packing_group_id Identifier of a packing group.
      # @param [Integer] page_size The number of packing group items to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_packing_group_items(inbound_plan_id, packing_group_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/packingGroups/#{packing_group_id}/items"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Sets packing information for an inbound plan. This should be called after an inbound plan is created to populate
      # the box level information required for planning and transportation estimates.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Hash] body The body of the request to `setPackingInformation`.
      # @return [Hash] The API response
      def set_packing_information(inbound_plan_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/packingInformation"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Retrieves a list of all packing options for an inbound plan. Packing options must first be generated by the
      # corresponding operation before becoming available.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Integer] page_size The number of packing options to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_packing_options(inbound_plan_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/packingOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Generates available packing options for the inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @return [Hash] The API response
      def generate_packing_options(inbound_plan_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/##{inbound_plan_id}/packingOptions"

        retriable(delay: proc { |i| 2.0 * i }).post(path)
      end

      # Confirms the packing option for an inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] packing_option_id Identifier of a packing option.
      # @return [Hash] The API response
      def confirm_packing_option(inbound_plan_id, packing_option_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/packingOptions/#{packing_option_id}/confirmation"

        retriable(delay: proc { |i| 2.0 * i }).post(path)
      end

      # Provides a paginated list of pallet packages in an inbound plan. An inbound plan will have pallets when the
      # related details are provided after generating Less-Than-Truckload (LTL) carrier shipments.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Integer] page_size The number of pallets to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_inbound_plan_pallets(inbound_plan_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/pallets"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Provides a list of all placement options for an inbound plan. Placement options must first be generated by the
      # corresponding operation before becoming available.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Integer] page_size The number of placement options to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_placement_options(inbound_plan_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/placementOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Generates placement options for the inbound plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Hash] body The body of the request to `generatePlacementOptions`.
      # @return [Hash] The API response
      def generate_placement_options(inbound_plan_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/##{inbound_plan_id}/placementOptions"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Confirms the placement option for an inbound plan. Once confirmed, it cannot be changed for the Inbound Plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] placement_option_id The identifier of a placement option. A placement option represents the
      #   shipment splits and destinations of SKUs.
      # @return [Hash] The API response
      def confirm_placement_option(inbound_plan_id, placement_option_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/placementOptions/#{placement_option_id}/confirmation"

        retriable(delay: proc { |i| 2.0 * i }).post(path)
      end

      # Provides the full details for a specific shipment within an inbound plan. The `transportationOptionId` inside
      # `acceptedTransportationSelection` can be used to retrieve the transportation details for the shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @return [Hash] The API response
      def get_shipment(inbound_plan_id, shipment_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}"

        retriable(delay: proc { |i| 2.0 * i }).get(path)
      end

      # Provides a paginated list of box packages in a shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Integer] page_size The number of boxes to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_shipment_boxes(inbound_plan_id, shipment_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/boxes"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Retrieve a paginated list of shipment content update previews for a given shipment. The shipment content update
      # preview is a summary of the requested shipment content changes along with the transportation cost implications
      # of the change that can only be confirmed prior to the expiry date specified.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Integer] page_size The number of content update previews to return.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_shipment_content_update_previews(inbound_plan_id, shipment_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/contentUpdatePreviews"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Generate a shipment content update preview given a set of intended boxes and/or items for a shipment with a
      # confirmed carrier. The shipment content update preview will be viewable with the updated costs and contents
      # prior to confirmation.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Hash] body The body of the request to `generateShipmentContentUpdatePreviews`.
      # @return [Hash] The API response
      def generate_shipment_content_update_previews(inbound_plan_id, shipment_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/##{inbound_plan_id}/shipments/##{shipment_id}/contentUpdatePreviews"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Retrieve a shipment content update preview which provides a summary of the requested shipment content changes
      # along with the transportation cost implications of the change that can only be confirmed prior to the expiry
      # date specified.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [String] content_update_preview_id Identifier of a content update preview.
      # @return [Hash] The API response
      def get_shipment_content_update_preview(inbound_plan_id, shipment_id, content_update_preview_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/contentUpdatePreviews/#{content_update_preview_id}"

        retriable(delay: proc { |i| 2.0 * i }).get(path)
      end

      # Confirm a shipment content update preview and accept the changes in transportation cost.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [String] content_update_preview_id Identifier of a content update preview.
      # @return [Hash] The API response
      def confirm_shipment_content_update_preview(inbound_plan_id, shipment_id, content_update_preview_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/contentUpdatePreviews/#{content_update_preview_id}/confirmation"

        retriable(delay: proc { |i| 2.0 * i }).post(path)
      end

      # Provide delivery challan document for PCP transportation in IN marketplace.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @return [Hash] The API response
      def get_delivery_challan_document(inbound_plan_id, shipment_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/deliveryChallanDocument"

        retriable(delay: proc { |i| 2.0 * i }).get(path)
      end

      # Retrieves all delivery window options for a shipment. Delivery window options must first be generated by the
      # `generateDeliveryWindowOptions` operation before becoming available.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id The shipment to get delivery window options for.
      # @param [Integer] page_size The number of delivery window options to return in the response matching the given
      #   query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_delivery_window_options(inbound_plan_id, shipment_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/deliveryWindowOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Generates available delivery window options for a given shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id The shipment to generate delivery window options for.
      # @return [Hash] The API response
      def generate_delivery_window_options(inbound_plan_id, shipment_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/##{inbound_plan_id}/shipments/##{shipment_id}/deliveryWindowOptions"

        retriable(delay: proc { |i| 2.0 * i }).post(path)
      end

      # Confirms the delivery window option for chosen shipment within an inbound plan. A placement option must be
      # confirmed prior to use of this API. Once confirmed, new delivery window options cannot be generated, but the
      # chosen delivery window option can be updated before shipment closure. The window is used to provide the expected
      # time when a shipment will arrive at the warehouse. All transportation options which have the program
      # `CONFIRMED_DELIVERY_WINDOW` require a delivery window to be confirmed prior to transportation option
      # confirmation.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id The shipment to confirm the delivery window option for.
      # @param [String] delivery_window_option_id The id of the delivery window option to be confirmed.
      # @return [Hash] The API response
      def confirm_delivery_window_options(inbound_plan_id, shipment_id, delivery_window_option_id)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/deliveryWindowOptions/#{delivery_window_option_id}/confirmation"

        retriable(delay: proc { |i| 2.0 * i }).post(path)
      end

      # Provides a paginated list of item packages in a shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Integer] page_size The number of items to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_shipment_items(inbound_plan_id, shipment_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/items"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Updates the name of an existing shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Hash] body The body of the request to `updateShipmentName`.
      # @return [Hash] The API response
      def update_shipment_name(inbound_plan_id, shipment_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/name"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).put(path, body:)
      end

      # Provides a paginated list of pallet packages in a shipment. A palletized shipment will have pallets when the
      # related details are provided after generating Less-Than-Truckload (LTL) carrier shipments.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Integer] page_size The number of pallets to return in the response matching the given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def list_shipment_pallets(inbound_plan_id, shipment_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/pallets"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Cancels a self-ship appointment slot against a shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Hash] body The body of the request to `cancelSelfShipAppointment`.
      # @return [Hash] The API response
      def cancel_self_ship_appointment(inbound_plan_id, shipment_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/selfShipAppointmentCancellation"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).put(path, body:)
      end

      # Retrieves a list of available self-ship appointment slots used to drop off a shipment at a warehouse.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Integer] page_size The number of self ship appointment slots to return in the response matching the
      #   given query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @return [Hash] The API response
      def get_self_ship_appointment_slots(inbound_plan_id, shipment_id, page_size: nil, pagination_token: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/selfShipAppointmentSlots"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Initiates the process of generating the appointment slots list.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Hash] body The body of the request to `generateSelfShipAppointmentSlots`.
      # @return [Hash] The API response
      def generate_self_ship_appointment_slots(inbound_plan_id, shipment_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/##{inbound_plan_id}/shipments/##{shipment_id}/selfShipAppointmentSlots"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Confirms or reschedules a self-ship appointment slot against a shipment.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [String] slot_id An identifier to a self-ship appointment slot.
      # @param [Hash] body The body of the request to `scheduleSelfShipAppointment`.
      # @return [Hash] The API response
      def schedule_self_ship_appointment(inbound_plan_id, shipment_id, slot_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/selfShipAppointmentSlots/#{slot_id}/schedule"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Updates the source address of an existing shipment. The shipment source address can only be updated prior to the
      # confirmation of the shipment carriers. As a result of the updated source address, existing transportation
      # options will be invalidated and will need to be regenerated to capture the potential difference in
      # transportation options and quotes due to the new source address.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Hash] body The body of the request to `updateShipmentSourceAddress`.
      # @return [Hash] The API response
      def update_shipment_source_address(inbound_plan_id, shipment_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/sourceAddress"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).put(path, body:)
      end

      # Updates a shipment's tracking details.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [String] shipment_id Identifier of a shipment. A shipment contains the boxes and units being inbounded.
      # @param [Hash] body The body of the request to `updateShipmentTrackingDetails`.
      # @return [Hash] The API response
      def update_shipment_tracking_details(inbound_plan_id, shipment_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/shipments/#{shipment_id}/trackingDetails"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).put(path, body:)
      end

      # Retrieves all transportation options for a shipment. Transportation options must first be generated by the
      # `generateTransportationOptions` operation before becoming available.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Integer] page_size The number of transportation options to return in the response matching the given
      #   query.
      # @param [String] pagination_token A token to fetch a certain page when there are multiple pages worth of results.
      #   The value of this token is fetched from the `pagination` returned in the API response. In the absence of the
      #   token value from the query parameter the API returns the first page of the result.
      # @param [String] placement_option_id The placement option to get transportation options for. Either
      #   `placementOptionId` or `shipmentId` must be specified.
      # @param [String] shipment_id The shipment to get transportation options for. Either `placementOptionId` or
      #   `shipmentId` must be specified.
      # @return [Hash] The API response
      def list_transportation_options(inbound_plan_id, page_size: nil, pagination_token: nil,
        placement_option_id: nil, shipment_id: nil)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/transportationOptions"
        params = {
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
          "placementOptionId" => placement_option_id,
          "shipmentId" => shipment_id,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Generates available transportation options for a given placement option.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Hash] body The body of the request to `generateTransportationOptions`.
      # @return [Hash] The API response
      def generate_transportation_options(inbound_plan_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/##{inbound_plan_id}/transportationOptions"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Confirms all the transportation options for an inbound plan. A placement option must be confirmed prior to use
      # of this API. Once confirmed, new transportation options can not be generated or confirmed for the Inbound Plan.
      #
      # @param [String] inbound_plan_id Identifier of an inbound plan.
      # @param [Hash] body The body of the request to `confirmTransportationOptions`.
      # @return [Hash] The API response
      def confirm_transportation_options(inbound_plan_id, body)
        path = "/inbound/fba/2024-03-20/inboundPlans/#{inbound_plan_id}/transportationOptions/confirmation"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # List the inbound compliance details for MSKUs in a given marketplace.
      #
      # @param [Array<String>] mskus List of merchant SKUs - a merchant-supplied identifier for a specific SKU.
      # @param [String] marketplace_id The Marketplace ID. Refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) for a list of possible values.
      # @return [Hash] The API response
      def list_item_compliance_details(mskus, marketplace_id)
        path = "/inbound/fba/2024-03-20/items/compliance"
        params = {
          "mskus" => mskus,
          "marketplaceId" => marketplace_id,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Update compliance details for list of MSKUs. The details provided here are only used for the IN marketplace
      # compliance validation.
      #
      # @param [String] marketplace_id The Marketplace ID. Refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) for a list of possible values.
      # @param [Hash] body The body of the request to `updateItemComplianceDetails`.
      # @return [Hash] The API response
      def update_item_compliance_details(marketplace_id, body)
        path = "/inbound/fba/2024-03-20/items/compliance"
        body = body
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).put(path, body:, params:)
      end

      # For a given marketplace - creates labels for a list of mskus.
      #
      # @param [Hash] body The body of the request to `createMarketplaceItemLabels`.
      # @return [Hash] The API response
      def create_marketplace_item_labels(body)
        path = "/inbound/fba/2024-03-20/items/labels"
        body = body

        retriable(delay: proc { |i| 2.0 * i }).post(path, body:)
      end

      # Gets the status of the processing of an asynchronous API call.
      #
      # @param [String] operation_id Identifier of an asynchronous operation.
      # @return [Hash] The API response
      def get_inbound_operation_status(operation_id)
        path = "/inbound/fba/2024-03-20/operations/#{operation_id}"

        retriable(delay: proc { |i| 2.0 * i }).get(path)
      end
    end
  end
end
