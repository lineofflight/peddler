# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def fulfillment_inbound_v0(...)
      APIs::FulfillmentInboundV0.new(...)
    end
  end

  module APIs
    # Selling Partner API for Fulfillment Inbound
    #
    # The Selling Partner API for Fulfillment Inbound lets you create applications that create and update inbound
    # shipments of inventory to Amazon's fulfillment network.
    class FulfillmentInboundV0 < API
      # Returns labeling requirements and item preparation instructions to help prepare items for shipment to Amazon's
      # fulfillment network.
      #
      # @note This operation can make a static sandbox call.
      # @param ship_to_country_code [String] The country code of the country to which the items will be shipped. Note
      #   that labeling requirements and item preparation instructions can vary by country.
      # @param seller_sku_list [Array<String>] A list of SellerSKU values. Used to identify items for which you want
      #   labeling requirements and item preparation instructions for shipment to Amazon's fulfillment network. The
      #   SellerSKU is qualified by the Seller ID, which is included with every call to the Seller Partner API. Note:
      #   Include seller SKUs that you have used to list items on Amazon's retail website. If you include a seller SKU
      #   that you have never used to list an item on Amazon's retail website, the seller SKU is returned in the
      #   InvalidSKUList property in the response.
      # @param asin_list [Array<String>] A list of ASIN values. Used to identify items for which you want item
      #   preparation instructions to help with item sourcing decisions. Note: ASINs must be included in the product
      #   catalog for at least one of the marketplaces that the seller participates in. Any ASIN that is not included in
      #   the product catalog for at least one of the marketplaces that the seller participates in is returned in the
      #   InvalidASINList property in the response. You can find out which marketplaces a seller participates in by
      #   calling the getMarketplaceParticipations operation in the Selling Partner API for Sellers.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_prep_instructions(ship_to_country_code, seller_sku_list: nil, asin_list: nil, rate_limit: 2.0)
        path = "/fba/inbound/v0/prepInstructions"
        params = {
          "ShipToCountryCode" => ship_to_country_code,
          "SellerSKUList" => stringify_array(seller_sku_list),
          "ASINList" => stringify_array(asin_list),
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns package/pallet labels for faster and more accurate shipment processing at the Amazon fulfillment center.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @param page_type [String] The page type to use to print the labels. Submitting a PageType value that is not
      #   supported in your marketplace returns an error.
      # @param label_type [String] The type of labels requested.
      # @param number_of_packages [Integer] The number of packages in the shipment.
      # @param package_labels_to_print [Array<String>] A list of identifiers that specify packages for which you want
      #   package labels printed. If you provide box content information with the [FBA Inbound Shipment Carton
      #   Information
      #   Feed](https://developer-docs.amazon.com/sp-api/docs/fulfillment-by-amazon-feed-type-values#fba-inbound-shipment-carton-information-feed),
      #   then `PackageLabelsToPrint` must match the `CartonId` values you provide through that feed. If you provide box
      #   content information with the Fulfillment Inbound API v2024-03-20, then `PackageLabelsToPrint` must match the
      #   `boxID` values from the
      #   [`listShipmentBoxes`](https://developer-docs.amazon.com/sp-api/docs/fulfillment-inbound-api-v2024-03-20-reference#listshipmentboxes)
      #   response. If these values do not match as required, the operation returns the `IncorrectPackageIdentifier`
      #   error code.
      # @param number_of_pallets [Integer] The number of pallets in the shipment. This returns four identical labels for
      #   each pallet.
      # @param page_size [Integer] The page size for paginating through the total packages' labels. This is a required
      #   parameter for Non-Partnered LTL Shipments. Max value:1000.
      # @param page_start_index [Integer] The page start index for paginating through the total packages' labels. This
      #   is a required parameter for Non-Partnered LTL Shipments.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_labels(shipment_id, page_type, label_type, number_of_packages: nil, package_labels_to_print: nil,
        number_of_pallets: nil, page_size: nil, page_start_index: nil, rate_limit: 2.0)
        path = "/fba/inbound/v0/shipments/#{percent_encode(shipment_id)}/labels"
        params = {
          "PageType" => page_type,
          "LabelType" => label_type,
          "NumberOfPackages" => number_of_packages,
          "PackageLabelsToPrint" => stringify_array(package_labels_to_print),
          "NumberOfPallets" => number_of_pallets,
          "PageSize" => page_size,
          "PageStartIndex" => page_start_index,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns a bill of lading for a Less Than Truckload/Full Truckload (LTL/FTL) shipment. The getBillOfLading
      # operation returns PDF document data for printing a bill of lading for an Amazon-partnered Less Than
      # Truckload/Full Truckload (LTL/FTL) inbound shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] A shipment identifier originally returned by the createInboundShipmentPlan
      #   operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_bill_of_lading(shipment_id, rate_limit: 2.0)
        path = "/fba/inbound/v0/shipments/#{percent_encode(shipment_id)}/billOfLading"

        meter(rate_limit).get(path)
      end

      # Returns a list of inbound shipments based on criteria that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_status_list [Array<String>] A list of ShipmentStatus values. Used to select shipments with a
      #   current status that matches the status values that you specify.
      # @param shipment_id_list [Array<String>] A list of shipment IDs used to select the shipments that you want. If
      #   both ShipmentStatusList and ShipmentIdList are specified, only shipments that match both parameters are
      #   returned.
      # @param last_updated_after [String] A date used for selecting inbound shipments that were last updated after (or
      #   at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param last_updated_before [String] A date used for selecting inbound shipments that were last updated before
      #   (or at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param query_type [String] Indicates whether shipments are returned using shipment information (by providing the
      #   ShipmentStatusList or ShipmentIdList parameters), using a date range (by providing the LastUpdatedAfter and
      #   LastUpdatedBefore parameters), or by using NextToken to continue returning items specified in a previous
      #   request.
      # @param next_token [String] A string token returned in the response to your previous request.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace where the product would be
      #   stored.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipments(query_type, marketplace_id, shipment_status_list: nil, shipment_id_list: nil,
        last_updated_after: nil, last_updated_before: nil, next_token: nil, rate_limit: 2.0)
        path = "/fba/inbound/v0/shipments"
        params = {
          "ShipmentStatusList" => stringify_array(shipment_status_list),
          "ShipmentIdList" => stringify_array(shipment_id_list),
          "LastUpdatedAfter" => last_updated_after,
          "LastUpdatedBefore" => last_updated_before,
          "QueryType" => query_type,
          "NextToken" => next_token,
          "MarketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns a list of items in a specified inbound shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] A shipment identifier used for selecting items in a specific inbound shipment.
      # @param marketplace_id [String] Deprecated. Do not use.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment_items_by_shipment_id(shipment_id, marketplace_id: nil, rate_limit: 2.0)
        path = "/fba/inbound/v0/shipments/#{percent_encode(shipment_id)}/items"
        params = {
          "MarketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns a list of items in a specified inbound shipment, or a list of items that were updated within a specified
      # time frame.
      #
      # @note This operation can make a static sandbox call.
      # @param last_updated_after [String] A date used for selecting inbound shipment items that were last updated after
      #   (or at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param last_updated_before [String] A date used for selecting inbound shipment items that were last updated
      #   before (or at) a specified time. The selection includes updates made by Amazon and by the seller.
      # @param query_type [String] Indicates whether items are returned using a date range (by providing the
      #   LastUpdatedAfter and LastUpdatedBefore parameters), or using NextToken, which continues returning items
      #   specified in a previous request.
      # @param next_token [String] A string token returned in the response to your previous request.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace where the product would be
      #   stored.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment_items(query_type, marketplace_id, last_updated_after: nil, last_updated_before: nil,
        next_token: nil, rate_limit: 2.0)
        path = "/fba/inbound/v0/shipmentItems"
        params = {
          "LastUpdatedAfter" => last_updated_after,
          "LastUpdatedBefore" => last_updated_before,
          "QueryType" => query_type,
          "NextToken" => next_token,
          "MarketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
