# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def easy_ship_2022_03_23(...)
      API::EasyShip20220323.new(...)
    end
  end

  class API
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
      # @return [Hash] The API response
      def list_handover_slots(list_handover_slots_request: nil, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/timeSlot"
        body = list_handover_slots_request

        meter(rate_limit).post(path, body:)
      end

      # Returns information about a package, including dimensions, weight, time slot information for handover, invoice
      # and item information, and status.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon-defined order identifier. Identifies the order that the seller wants
      #   to deliver using Amazon Easy Ship.
      # @param marketplace_id [String] An identifier for the marketplace in which the seller is selling.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def get_scheduled_package(amazon_order_id, marketplace_id, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/package"
        params = {
          "amazonOrderId" => amazon_order_id,
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
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
      # @return [Hash] The API response
      def create_scheduled_package(create_scheduled_package_request, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/package"
        body = create_scheduled_package_request

        meter(rate_limit).post(path, body:)
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
      # @return [Hash] The API response
      def update_scheduled_packages(update_scheduled_packages_request: nil, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/package"
        body = update_scheduled_packages_request

        meter(rate_limit).patch(path, body:)
      end

      # This operation automatically schedules a time slot for all the `amazonOrderId`s given as input, generating the
      # associated shipping labels, along with other compliance documents according to the marketplace (refer to the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # marketplace document support table}). Developers calling this operation may optionally assign a `packageDetails`
      # object, allowing them to input a preferred time slot for each order in ther request. In this case, Amazon will
      # try to schedule the respective packages using their optional settings. On the other hand, *i.e.*, if the time
      # slot is not provided, Amazon will then pick the earliest time slot possible. Regarding the shipping label's file
      # format, external developers are able to choose between PDF or ZPL, and Amazon will create the label accordingly.
      # This operation returns an array composed of the scheduled packages, and a short-lived URL pointing to a zip file
      # containing the generated shipping labels and the other documents enabled for your marketplace. If at least an
      # order couldn't be scheduled, then Amazon adds the `rejectedOrders` list into the response, which contains an
      # entry for each order we couldn't process. Each entry is composed of an error message describing the reason of
      # the failure, so that sellers can take action. The table below displays the supported request and burst maximum
      # rates:
      #
      # @note This operation can make a static sandbox call.
      # @param create_scheduled_packages_request [Hash] The request schema for the `createScheduledPackageBulk`
      #   operation.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def create_scheduled_package_bulk(create_scheduled_packages_request, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/packages/bulk"
        body = create_scheduled_packages_request

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
