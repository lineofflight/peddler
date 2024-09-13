# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Fulfillment Inbound
    #
    # The Selling Partner API for Fulfillment Inbound lets you create applications that create and update inbound
    # shipments of inventory to Amazon's fulfillment network.
    class FulfillmentInboundV0 < API
      # Returns one or more inbound shipment plans, which provide the information you need to create one or more inbound
      # shipments for a set of items that you specify. Multiple inbound shipment plans might be required so that items
      # can be optimally placed in Amazon's fulfillment network—for example, positioning inventory closer to the
      # customer. Alternatively, two inbound shipment plans might be created with the same Amazon fulfillment center
      # destination if the two shipment plans require different processing—for example, items that require labels must
      # be shipped separately from stickerless, commingled inventory.
      #
      # @param [Hash] body The request schema for the CreateInboundShipmentPlanRequest operation.
      # @return [Hash] The API response
      def create_inbound_shipment_plan(body)
        path = "/fba/inbound/v0/plans"

        rate_limit(2.0).post(path, body:)
      end

      # Returns a new inbound shipment based on the specified shipmentId that was returned by the
      # createInboundShipmentPlan operation.
      #
      # @param [Hash] body The request schema for the InboundShipmentRequest operation.
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def create_inbound_shipment(body, shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}"

        rate_limit(2.0).post(path, body:)
      end

      # Updates or removes items from the inbound shipment identified by the specified shipment identifier. Adding new
      # items is not supported.
      #
      # @param [Hash] body The request schema for the InboundShipmentRequest operation.
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def update_inbound_shipment(body, shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}"

        rate_limit(2.0).put(path, body:)
      end

      # Returns pre-order information, including dates, that a seller needs before confirming a shipment for pre-order.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace the shipment is tied to.
      # @return [Hash] The API response
      def get_preorder_info(shipment_id, marketplace_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/preorder"
        params = {
          "MarketplaceId" => marketplace_id,
        }.compact

        rate_limit(2.0).get(path, params:)
      end

      # Returns information needed to confirm a shipment for pre-order. Call this operation after calling the
      # getPreorderInfo operation to get the NeedByDate value and other pre-order information about the shipment.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @param [String] need_by_date Date that the shipment must arrive at the Amazon fulfillment center to avoid
      #   delivery promise breaks for pre-ordered items. Must be in YYYY-MM-DD format. The response to the
      #   getPreorderInfo operation returns this value.
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace the shipment is tied to.
      # @return [Hash] The API response
      def confirm_preorder(shipment_id, need_by_date, marketplace_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/preorder/confirm"
        params = {
          "NeedByDate" => need_by_date,
          "MarketplaceId" => marketplace_id,
        }.compact

        rate_limit(2.0).put(path, params:)
      end

      # Returns labeling requirements and item preparation instructions to help prepare items for shipment to Amazon's
      # fulfillment network.
      #
      # @param [String] ship_to_country_code The country code of the country to which the items will be shipped. Note
      #   that labeling requirements and item preparation instructions can vary by country.
      # @param [Array<String>] seller_sku_list A list of SellerSKU values. Used to identify items for which you want
      #   labeling requirements and item preparation instructions for shipment to Amazon's fulfillment network. The
      #   SellerSKU is qualified by the Seller ID, which is included with every call to the Seller Partner API. Note:
      #   Include seller SKUs that you have used to list items on Amazon's retail website. If you include a seller SKU
      #   that you have never used to list an item on Amazon's retail website, the seller SKU is returned in the
      #   InvalidSKUList property in the response.
      # @param [Array<String>] asin_list A list of ASIN values. Used to identify items for which you want item
      #   preparation instructions to help with item sourcing decisions. Note: ASINs must be included in the product
      #   catalog for at least one of the marketplaces that the seller participates in. Any ASIN that is not included in
      #   the product catalog for at least one of the marketplaces that the seller participates in is returned in the
      #   InvalidASINList property in the response. You can find out which marketplaces a seller participates in by
      #   calling the getMarketplaceParticipations operation in the Selling Partner API for Sellers.
      # @return [Hash] The API response
      def get_prep_instructions(ship_to_country_code, seller_sku_list: nil, asin_list: nil)
        path = "/fba/inbound/v0/prepInstructions"
        params = {
          "ShipToCountryCode" => ship_to_country_code,
          "SellerSKUList" => seller_sku_list,
          "ASINList" => asin_list,
        }.compact

        rate_limit(2.0).get(path, params:)
      end

      # Returns current transportation information about an inbound shipment.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def get_transport_details(shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/transport"

        rate_limit(2.0).get(path)
      end

      # Sends transportation information to Amazon about an inbound shipment.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @param [Hash] body The request schema for the PutTransportDetailsRequest operation.
      # @return [Hash] The API response
      def put_transport_details(shipment_id, body)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/transport"

        rate_limit(2.0).put(path, body:)
      end

      # Cancels a previously-confirmed request to ship an inbound shipment using an Amazon-partnered carrier. To be
      # successful, you must call this operation before the VoidDeadline date that is returned by the
      # getTransportDetails operation. Important: The VoidDeadline date is 24 hours after you confirm a Small Parcel
      # shipment transportation request or one hour after you confirm a Less Than Truckload/Full Truckload (LTL/FTL)
      # shipment transportation request. After the void deadline passes, your account will be charged for the shipping
      # cost.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def void_transport(shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/transport/void"

        rate_limit(2.0).post(path)
      end

      # Initiates the process of estimating the shipping cost for an inbound shipment by an Amazon-partnered carrier.
      # Prior to calling the estimateTransport operation, you must call the putTransportDetails operation to provide
      # Amazon with the transportation information for the inbound shipment.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def estimate_transport(shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/transport/estimate"

        rate_limit(2.0).post(path)
      end

      # Confirms that the seller accepts the Amazon-partnered shipping estimate, agrees to allow Amazon to charge their
      # account for the shipping cost, and requests that the Amazon-partnered carrier ship the inbound shipment. Prior
      # to calling the confirmTransport operation, you should call the getTransportDetails operation to get the
      # Amazon-partnered shipping estimate. Important: After confirming the transportation request, if the seller
      # decides that they do not want the Amazon-partnered carrier to ship the inbound shipment, you can call the
      # voidTransport operation to cancel the transportation request. Note that for a Small Parcel shipment, the seller
      # has 24 hours after confirming a transportation request to void the transportation request. For a Less Than
      # Truckload/Full Truckload (LTL/FTL) shipment, the seller has one hour after confirming a transportation request
      # to void it. After the grace period has expired the seller's account will be charged for the shipping cost.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def confirm_transport(shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/transport/confirm"

        rate_limit(2.0).post(path)
      end

      # Returns package/pallet labels for faster and more accurate shipment processing at the Amazon fulfillment center.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @param [String] page_type The page type to use to print the labels. Submitting a PageType value that is not
      #   supported in your marketplace returns an error.
      # @param [String] label_type The type of labels requested.
      # @param [Integer] number_of_packages The number of packages in the shipment.
      # @param [Array<String>] package_labels_to_print A list of identifiers that specify packages for which you want
      #   package labels printed. Must match CartonId values previously passed using the FBA Inbound Shipment Carton
      #   Information Feed. If not, the operation returns the IncorrectPackageIdentifier error code.
      # @param [Integer] number_of_pallets The number of pallets in the shipment. This returns four identical labels for
      #   each pallet.
      # @param [Integer] page_size The page size for paginating through the total packages' labels. This is a required
      #   parameter for Non-Partnered LTL Shipments. Max value:1000.
      # @param [Integer] page_start_index The page start index for paginating through the total packages' labels. This
      #   is a required parameter for Non-Partnered LTL Shipments.
      # @return [Hash] The API response
      def get_labels(shipment_id, page_type, label_type, number_of_packages: nil, package_labels_to_print: nil,
        number_of_pallets: nil, page_size: nil, page_start_index: nil)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/labels"
        params = {
          "PageType" => page_type,
          "LabelType" => label_type,
          "NumberOfPackages" => number_of_packages,
          "PackageLabelsToPrint" => package_labels_to_print,
          "NumberOfPallets" => number_of_pallets,
          "PageSize" => page_size,
          "PageStartIndex" => page_start_index,
        }.compact

        rate_limit(2.0).get(path, params:)
      end

      # Returns a bill of lading for a Less Than Truckload/Full Truckload (LTL/FTL) shipment. The getBillOfLading
      # operation returns PDF document data for printing a bill of lading for an Amazon-partnered Less Than
      # Truckload/Full Truckload (LTL/FTL) inbound shipment.
      #
      # @param [String] shipment_id A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @return [Hash] The API response
      def get_bill_of_lading(shipment_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/billOfLading"

        rate_limit(2.0).get(path)
      end

      # Returns a list of inbound shipments based on criteria that you specify.
      #
      # @param [Array<String>] shipment_status_list A list of ShipmentStatus values. Used to select shipments with a
      #   current status that matches the status values that you specify.
      # @param [Array<String>] shipment_id_list A list of shipment IDs used to select the shipments that you want. If
      #   both ShipmentStatusList and ShipmentIdList are specified, only shipments that match both parameters are
      #   returned.
      # @param [String] last_updated_after A date used for selecting inbound shipments that were last updated after (or
      #   at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param [String] last_updated_before A date used for selecting inbound shipments that were last updated before
      #   (or at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param [String] query_type Indicates whether shipments are returned using shipment information (by providing the
      #   ShipmentStatusList or ShipmentIdList parameters), using a date range (by providing the LastUpdatedAfter and
      #   LastUpdatedBefore parameters), or by using NextToken to continue returning items specified in a previous
      #   request.
      # @param [String] next_token A string token returned in the response to your previous request.
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace where the product would be
      #   stored.
      # @return [Hash] The API response
      def get_shipments(query_type, marketplace_id, shipment_status_list: nil, shipment_id_list: nil,
        last_updated_after: nil, last_updated_before: nil, next_token: nil)
        path = "/fba/inbound/v0/shipments"
        params = {
          "ShipmentStatusList" => shipment_status_list,
          "ShipmentIdList" => shipment_id_list,
          "LastUpdatedAfter" => last_updated_after,
          "LastUpdatedBefore" => last_updated_before,
          "QueryType" => query_type,
          "NextToken" => next_token,
          "MarketplaceId" => marketplace_id,
        }.compact

        rate_limit(2.0).get(path, params:)
      end

      # Returns a list of items in a specified inbound shipment.
      #
      # @param [String] shipment_id A shipment identifier used for selecting items in a specific inbound shipment.
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace where the product would be
      #   stored.
      # @return [Hash] The API response
      def get_shipment_items_by_shipment_id(shipment_id, marketplace_id)
        path = "/fba/inbound/v0/shipments/#{shipment_id}/items"
        params = {
          "MarketplaceId" => marketplace_id,
        }.compact

        rate_limit(2.0).get(path, params:)
      end

      # Returns a list of items in a specified inbound shipment, or a list of items that were updated within a specified
      # time frame.
      #
      # @param [String] last_updated_after A date used for selecting inbound shipment items that were last updated after
      #   (or at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param [String] last_updated_before A date used for selecting inbound shipment items that were last updated
      #   before (or at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param [String] query_type Indicates whether items are returned using a date range (by providing the
      #   LastUpdatedAfter and LastUpdatedBefore parameters), or using NextToken, which continues returning items
      #   specified in a previous request.
      # @param [String] next_token A string token returned in the response to your previous request.
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace where the product would be
      #   stored.
      # @return [Hash] The API response
      def get_shipment_items(query_type, marketplace_id, last_updated_after: nil, last_updated_before: nil,
        next_token: nil)
        path = "/fba/inbound/v0/shipmentItems"
        params = {
          "LastUpdatedAfter" => last_updated_after,
          "LastUpdatedBefore" => last_updated_before,
          "QueryType" => query_type,
          "NextToken" => next_token,
          "MarketplaceId" => marketplace_id,
        }.compact

        rate_limit(2.0).get(path, params:)
      end
    end
  end
end
