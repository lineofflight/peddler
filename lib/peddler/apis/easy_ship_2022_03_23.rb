# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def easy_ship_2022_03_23(...)
      APIs::EasyShip20220323.new(...)
    end
  end

  module APIs
    # Selling Partner API for Easy Ship
    #
    # The Selling Partner API for Easy Ship helps you build applications that help sellers manage and ship Amazon Easy
    # Ship orders. Your Easy Ship applications can: * Get available time slots for packages to be scheduled for
    # delivery. * Schedule, reschedule, and cancel Easy Ship orders. * Print labels, invoices, and warranties. See the
    # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
    # Marketplace Support Table} for the differences in Easy Ship operations by marketplace.
    class EasyShip20220323 < API
      # Returns time slots available for Easy Ship orders to be scheduled based on the package weight and dimensions
      # that the seller specifies. This operation is available for scheduled and unscheduled orders based on marketplace
      # support. See **Get Time Slots** in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table}. This operation can return time slots that have either pickup or drop-off handover
      # methods - see **Supported Handover Methods** in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table}.
      #
      # @note This operation can make a static sandbox call.
      # @param list_handover_slots_request [Hash] The request schema for the `listHandoverSlots` operation.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def list_handover_slots(list_handover_slots_request: nil, rate_limit: 1.0, tries: 2)
        path = "/easyShip/2022-03-23/timeSlot"
        body = list_handover_slots_request

        meter(rate_limit, tries:).post(path, body:)
      end

      # Returns information about a package, including dimensions, weight, time slot information for handover, invoice
      # and item information, and status.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon-defined order identifier. Identifies the order that the seller wants
      #   to deliver using Amazon Easy Ship.
      # @param marketplace_id [String] An identifier for the marketplace in which the seller is selling.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def get_scheduled_package(amazon_order_id, marketplace_id, rate_limit: 1.0, tries: 2)
        path = "/easyShip/2022-03-23/package"
        params = {
          "amazonOrderId" => amazon_order_id,
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit, tries:).get(path, params:)
      end

      # Schedules an Easy Ship order and returns the scheduled package information. This operation does the following: *
      # Specifies the time slot and handover method for the order to be scheduled for delivery. * Updates the Easy Ship
      # order status. * Generates a shipping label and an invoice. Calling `createScheduledPackage` also generates a
      # warranty document if you specify a `SerialNumber` value. To get these documents, see
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide How to get invoice,
      # shipping label, and warranty documents}. * Shows the status of Easy Ship orders when you call the `getOrders`
      # operation of the Selling Partner API for Orders and examine the `EasyShipShipmentStatus` property in the
      # response body. See the **Shipping Label**, **Invoice**, and **Warranty** columns in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table} to see which documents are supported in each marketplace.
      #
      # @note This operation can make a static sandbox call.
      # @param create_scheduled_package_request [Hash] The request schema for the `createScheduledPackage` operation.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def create_scheduled_package(create_scheduled_package_request, rate_limit: 1.0, tries: 2)
        path = "/easyShip/2022-03-23/package"
        body = create_scheduled_package_request

        meter(rate_limit, tries:).post(path, body:)
      end

      # Updates the time slot for handing over the package indicated by the specified `scheduledPackageId`. You can get
      # the new `slotId` value for the time slot by calling the `listHandoverSlots` operation before making another
      # `patch` call. See the **Update Package** column in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table} to see which marketplaces this operation is supported in.
      #
      # @note This operation can make a static sandbox call.
      # @param update_scheduled_packages_request [Hash] The request schema for the `updateScheduledPackages` operation.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def update_scheduled_packages(update_scheduled_packages_request: nil, rate_limit: 1.0, tries: 2)
        path = "/easyShip/2022-03-23/package"
        body = update_scheduled_packages_request

        meter(rate_limit, tries:).patch(path, body:)
      end

      # This operation automatically schedules a time slot for all specified `amazonOrderId` values and generates the
      # associated shipping labels and compliance documents based on the marketplace. For more information, refer to the
      # [marketplace support
      # table](https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table).
      # You can optionally assign a `packageDetails` object to input a preferred time slot for each order in your
      # request. In such cases, Amazon schedules the respective packages using the specified optional settings. If you
      # don't specify a time slot, Amazon assigns the earliest available time slot. You can choose PDF or ZPL for your
      # shipping label's file format and Amazon creates the label accordingly. This operation returns an array that
      # contains the scheduled packages, and a temporary URL that you can use to access a ZIP file. The ZIP file
      # includes the generated shipping labels and any other documents that are required for your marketplace. If an
      # order can't be scheduled, Amazon adds the `rejectedOrders` list in the response. The response contains an entry
      # for each order that could not be processed. Each entry contains an error message that describes the reason for
      # the failure. The following table contains the supported request and burst maximum rates:
      #
      # @note This operation can make a static sandbox call.
      # @param create_scheduled_packages_request [Hash] The request schema for the `createScheduledPackageBulk`
      #   operation.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def create_scheduled_package_bulk(create_scheduled_packages_request, rate_limit: 1.0, tries: 2)
        path = "/easyShip/2022-03-23/packages/bulk"
        body = create_scheduled_packages_request

        meter(rate_limit, tries:).post(path, body:)
      end
    end
  end
end
