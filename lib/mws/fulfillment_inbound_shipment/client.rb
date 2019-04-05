# frozen_string_literal: true

require 'peddler/client'

module MWS
  module FulfillmentInboundShipment
    # With the Fulfillment Inbound Shipment API, you can create and update
    # inbound shipments of inventory in the Amazon Fulfillment Network. You can
    # also request lists of inbound shipments or inbound shipment items based on
    # criteria that you specify.
    class Client < ::Peddler::Client
      self.version = '2010-10-01'
      self.path = "/FulfillmentInboundShipment/#{version}"

      # Returns inbound guidance for a list of items by Seller SKU
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetInboundGuidanceForSKU.html
      # @param [String] marketplace_id
      # @param [Array<String>] seller_sku_list
      # @return [Peddler::XMLParser]
      def get_inbound_guidance_for_sku(marketplace_id, *seller_sku_list)
        operation('GetInboundGuidanceForSKU')
          .add('MarketplaceId' => marketplace_id,
               'SellerSKUList' => seller_sku_list)
          .structure!('SellerSKUList', 'Id')

        run
      end

      # Returns inbound guidance for a list of items by ASIN
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetInboundGuidanceForASIN.html
      # @param [String] marketplace_id
      # @param [Array<String>] asin_list
      # @return [Peddler::XMLParser]
      def get_inbound_guidance_for_asin(marketplace_id, *asin_list)
        operation('GetInboundGuidanceForASIN')
          .add('MarketplaceId' => marketplace_id, 'ASINList' => asin_list)
          .structure!('ASINList', 'Id')

        run
      end

      # Returns the information required to create an inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_CreateInboundShipmentPlan.html
      # @param [Struct, Hash] ship_from_address
      # @param [Array<Struct, Hash>] inbound_shipment_plan_request_items
      # @param [Hash] opts
      # @option opts [String] :ship_to_country_code
      # @option opts [String] :ship_to_country_subdivision_code
      # @option opts [String] :label_prep_preference
      # @return [Peddler::XMLParser]
      def create_inbound_shipment_plan(ship_from_address,
                                       inbound_shipment_plan_request_items,
                                       opts = {})
        operation('CreateInboundShipmentPlan')
          .add(opts)
          .add('ShipFromAddress' => ship_from_address,
               'InboundShipmentPlanRequestItems' =>
                 inbound_shipment_plan_request_items)
          .structure!('InboundShipmentPlanRequestItems', 'member')
          .structure!('PrepDetailsList', 'member')

        run
      end

      # Creates an inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_CreateInboundShipment.html
      # @param [String] shipment_id
      # @param [Struct, Hash] inbound_shipment_header
      # @param [Array<Struct, Hash>] :inbound_shipment_items
      # @return [Peddler::XMLParser]
      def create_inbound_shipment(shipment_id, inbound_shipment_header,
                                  inbound_shipment_items)
        build_inbound_shipment_operation('CreateInboundShipment', shipment_id,
                                         inbound_shipment_header,
                                         inbound_shipment_items)

        run
      end

      # Updates an existing inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_UpdateInboundShipment.html
      # @param [String] shipment_id
      # @param [Struct, Hash] inbound_shipment_header
      # @param [Array<Struct, Hash>] :inbound_shipment_items
      # @return [Peddler::XMLParser]
      def update_inbound_shipment(shipment_id, inbound_shipment_header,
                                  inbound_shipment_items)
        build_inbound_shipment_operation('UpdateInboundShipment', shipment_id,
                                         inbound_shipment_header,
                                         inbound_shipment_items)

        run
      end

      # Returns pre-order information, including dates
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetPreorderInfo.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def get_preorder_info(shipment_id)
        operation('GetPreorderInfo')
          .add('ShipmentId' => shipment_id)

        run
      end

      # Confirms a shipment for pre-order
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_ConfirmPreorder.html
      # @param [String] shipment_id
      # @param [#iso8601] need_by_date
      # @return [Peddler::XMLParser]
      def confirm_preorder(shipment_id, need_by_date)
        operation('ConfirmPreorder')
          .add('ShipmentId' => shipment_id, 'NeedByDate' => need_by_date)

        run
      end

      # Returns labeling requirements and item preparation instructions to help
      # you prepare items for an inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetPrepInstructionsForSKU.html
      # @param [String] ship_to_country_code
      # @param [Array<String>] seller_sku_list
      # @return [Peddler::XMLParser]
      def get_prep_instructions_for_sku(ship_to_country_code, *seller_sku_list)
        operation('GetPrepInstructionsForSKU')
          .add('SellerSKUList' => seller_sku_list,
               'ShipToCountryCode' => ship_to_country_code)
          .structure!('SellerSKUList', 'Id')

        run
      end

      # Returns item preparation instructions to help with item sourcing
      # decisions
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetPrepInstructionsForASIN.html
      # @param [String] ship_to_country_code
      # @param [Array<String>] asin_list
      # @return [Peddler::XMLParser]
      def get_prep_instructions_for_asin(ship_to_country_code, *asin_list)
        operation('GetPrepInstructionsForASIN')
          .add('ASINList' => asin_list,
               'ShipToCountryCode' => ship_to_country_code)
          .structure!('ASINList', 'Id')

        run
      # Work around a bug upstream
      #
      # @see https://github.com/hakanensari/peddler/issues/122
      rescue Peddler::Errors::Error => e
        raise unless e.message.include?("Value null at 'asinList'")

        get_prep_instructions_for_asin_with_bad_params(ship_to_country_code,
                                                       *asin_list)
      end

      # Sends transportation information to Amazon about an inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_PutTransportContent.html
      # @param [String] shipment_id
      # @param [Boolean] is_partnered
      # @param [String] shipment_type
      # @param [Struct, Hash] transport_details
      # @return [Peddler::XMLParser]
      def put_transport_content(shipment_id, is_partnered, shipment_type,
                                transport_details)
        operation('PutTransportContent')
          .add('ShipmentId' => shipment_id, 'IsPartnered' => is_partnered,
               'ShipmentType' => shipment_type,
               'TransportDetails' => transport_details)
          .structure!('PackageList', 'member')
          .structure!('PalletList', 'member')

        run
      end

      # Requests an estimate of the shipping cost for an inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_EstimateTransportRequest.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def estimate_transport_request(shipment_id)
        operation('EstimateTransportRequest')
          .add('ShipmentId' => shipment_id)

        run
      end

      # Returns current transportation information about an inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetTransportContent.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def get_transport_content(shipment_id)
        operation('GetTransportContent')
          .add('ShipmentId' => shipment_id)

        run
      end

      # Confirms that you accept the Amazon-partnered shipping estimate and you
      # request that the Amazon-partnered carrier ship your inbound shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_ConfirmTransportRequest.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def confirm_transport_request(shipment_id)
        operation('ConfirmTransportRequest')
          .add('ShipmentId' => shipment_id)

        run
      end

      # Voids a previously-confirmed request to ship your inbound shipment using
      # an Amazon-partnered carrier
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_VoidTransportRequest.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def void_transport_request(shipment_id)
        operation('VoidTransportRequest')
          .add('ShipmentId' => shipment_id)

        run
      end

      # Returns PDF document data for printing package labels for an inbound
      # shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetPackageLabels.html
      # @param [String] shipment_id
      # @param [String] page_type
      # @param [Hash] opts
      # @option opts [Integer] :number_of_packages
      # @return [Peddler::XMLParser]
      def get_package_labels(shipment_id, page_type, opts = {})
        operation('GetPackageLabels')
          .add(opts)
          .add('ShipmentId' => shipment_id, 'PageType' => page_type)

        run
      end

      # Returns unique package labels for faster and more accurate shipment
      # processing at the Amazon fulfillment centre
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetUniquePackageLabels.html
      # @param [String] shipment_id
      # @param [String] page_type
      # @param [Array<String>] package_labels_to_print
      # @return [Peddler::XMLParser]
      def get_unique_package_labels(shipment_id, page_type,
                                    package_labels_to_print)
        operation('GetUniquePackageLabels')
          .add('ShipmentId' => shipment_id, 'PageType' => page_type,
               'PackageLabelsToPrint' => package_labels_to_print)
          .structure!('PackageLabelsToPrint', 'member')

        run
      end

      # Returns pallet labels
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetPalletLabels.html
      # @param [String] shipment_id
      # @param [String] page_type
      # @param [Integer] number_of_pallets
      # @return [Peddler::XMLParser]
      def get_pallet_labels(shipment_id, page_type, number_of_pallets)
        operation('GetPalletLabels')
          .add('ShipmentId' => shipment_id, 'PageType' => page_type,
               'NumberOfPallets' => number_of_pallets)

        run
      end

      # Returns PDF document data for printing a bill of lading for an inbound
      # shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_GetBillOfLading.html
      # @param [String] shipment_id
      # @return [Peddler::XMLParser]
      def get_bill_of_lading(shipment_id)
        operation('GetBillOfLading')
          .add('ShipmentId' => shipment_id)
        run
      end

      # Returns a list of inbound shipments based on criteria that you specify
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_ListInboundShipments.html
      # @param [Hash] opts
      # @option opts [Array<String>] :shipment_status_list
      # @option opts [Array<String>] :shipment_id_list
      # @option opts [String, #iso8601] :last_updated_after
      # @option opts [String, #iso8601] :last_updated_before
      # @return [Peddler::XMLParser]
      def list_inbound_shipments(opts = {})
        operation('ListInboundShipments')
          .add(opts)
          .structure!('ShipmentStatusList', 'member')
          .structure!('ShipmentIdList', 'member')

        run
      end

      # Returns the next page of inbound shipments
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_ListInboundShipmentsByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def list_inbound_shipments_by_next_token(next_token)
        operation('ListInboundShipmentsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Returns a list of items in a specified inbound shipment, or a list of
      # items that were updated within a specified time frame
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_ListInboundShipmentItems.html
      # @param [Hash] opts
      # @option opts [String] :shipment_id
      # @option opts [String, #iso8601] :last_updated_after
      # @option opts [String, #iso8601] :last_updated_before
      # @return [Peddler::XMLParser]
      def list_inbound_shipment_items(opts = {})
        operation('ListInboundShipmentItems')
          .add(opts)

        run
      end

      # Returns the next page of inbound shipment items
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_ListInboundShipmentItemsByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def list_inbound_shipment_items_by_next_token(next_token)
        operation('ListInboundShipmentItemsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets the operational status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/fba_inbound/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end

      private

      def build_inbound_shipment_operation(operation_name, shipment_id,
                                           inbound_shipment_header,
                                           inbound_shipment_items)
        operation(operation_name)
          .add('ShipmentId' => shipment_id,
               'InboundShipmentHeader' => inbound_shipment_header,
               'InboundShipmentItems' => inbound_shipment_items)
          .structure!('InboundShipmentItems', 'member')
          .structure!('PrepDetailsList', 'member')
      end

      def get_prep_instructions_for_asin_with_bad_params(_ship_to_country_code,
                                                         *asin_list)
        operation
          .add('AsinList' => asin_list)
          .structure!('AsinList', 'Id')
          .delete_if { |key, _val| key.include?('ASINList') }

        run
      end
    end
  end
end
