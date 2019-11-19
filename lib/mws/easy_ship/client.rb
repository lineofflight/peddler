# frozen_string_literal: true

require 'peddler/client'

module MWS
  module EasyShip
    # With the Easy Ship API section, you can build applications that help
    # sellers in India manage and ship their Amazon Easy Ship orders.
    #
    # @note This functionality is available only in the India marketplace.
    class Client < ::Peddler::Client
      self.version = '2018-09-01'
      self.path = "/EasyShip/#{version}"

      # Returns time slots for Amazon Easy Ship package pickup
      #
      # @see https://docs.developer.amazonservices.com/en_US/easy_ship/EasyShip_ListPickupSlots.html
      # @param [String] marketplace_id
      # @param [String] amazon_order_id
      # @param [Struct, Hash] package_dimensions
      # @param [Struct, Hash] package_weight
      # @return [Peddler::XMLParser]
      def list_pickup_slots(marketplace_id, amazon_order_id, package_dimensions,
                            package_weight)
        operation('ListPickupSlots')
          .add('MarketplaceId' => marketplace_id,
               'AmazonOrderId' => amazon_order_id,
               'PackageDimensions' => package_dimensions,
               'PackageWeight' => package_weight)

        run
      end

      # Schedules an Amazon Easy Ship pickup slot
      #
      # @see https://docs.developer.amazonservices.com/en_US/easy_ship/EasyShip_CreateScheduledPackage.html
      # @param [String] marketplace_id
      # @param [String] amazon_order_id
      # @param [Struct, Hash] package_request_details
      # @return [Peddler::XMLParser]
      def create_scheduled_package(marketplace_id, amazon_order_id,
                                   package_request_details)
        operation('CreateScheduledPackage')
          .add('MarketplaceId' => marketplace_id,
               'AmazonOrderId' => amazon_order_id,
               'PackageRequestDetails' => package_request_details)

        run
      end

      # Updates an Amazon Easy Ship pickup slot
      #
      # @see https://docs.developer.amazonservices.com/en_US/easy_ship/EasyShip_UpdateScheduledPackages.html
      # @param [String] marketplace_id
      # @param [Array<Struct, Hash>] scheduled_package_update_details_list
      # @return [Peddler::XMLParser]
      def update_scheduled_packages(marketplace_id,
                                    scheduled_package_update_details_list)
        operation('UpdateScheduledPackages')
          .add('MarketplaceId' => marketplace_id,
               'ScheduledPackageUpdateDetailsList' =>
                 scheduled_package_update_details_list)
          .structure!('ScheduledPackageUpdateDetailsList',
                      'PackageUpdateDetails')

        run
      end

      # Returns information about a scheduled package
      #
      # @see https://docs.developer.amazonservices.com/en_US/easy_ship/EasyShip_GetScheduledPackage.html
      # @param [String] marketplace_id
      # @param [Struct, Hash] scheduled_package_id
      # @return [Peddler::XMLParser]
      def get_scheduled_package(marketplace_id, scheduled_package_id)
        operation('GetScheduledPackage')
          .add('MarketplaceId' => marketplace_id,
               'ScheduledPackageId' => scheduled_package_id)

        run
      end

      # Returns the operational status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/shipment_invoicing/ShipmentInvoicing_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
