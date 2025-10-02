# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def easy_ship_2022_03_23
      api = APIs::EasyShip20220323
      typed? ? api.typed : api
    end
  end

  module APIs
    # Selling Partner API for Easy Ship
    #
    # Use the Selling Partner API for Easy Ship to build applications for sellers to manage and ship Amazon Easy Ship
    # orders. With this API, you can get available time slots, schedule and reschedule Easy Ship orders, and print
    # shipping labels, invoices, and warranties. To review the differences in Easy Ship operations by marketplace, refer
    # to [Marketplace
    # support](https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support).
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/easy-ship-model/easyShip_2022-03-23.json
    class EasyShip20220323 < API
      # Returns time slots available for Easy Ship orders to be scheduled based on the package weight and dimensions
      # that the seller specifies.
      #
      # This operation is available for scheduled and unscheduled orders based on marketplace support. See **Get Time
      # Slots** in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table}.
      #
      # This operation can return time slots that have either pickup or drop-off handover methods - see **Supported
      # Handover Methods** in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table}.
      #
      # @note This operation can make a static sandbox call.
      # @param list_handover_slots_request [Hash] The request schema for the `listHandoverSlots` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_handover_slots(list_handover_slots_request: nil, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/timeSlot"
        body = list_handover_slots_request
        parser = Peddler::Types::EasyShip20220323::ListHandoverSlotsResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns information about a package, including dimensions, weight, time slot information for handover, invoice
      # and item information, and status.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon-defined order identifier. Identifies the order that the seller wants
      #   to deliver using Amazon Easy Ship.
      # @param marketplace_id [String] An identifier for the marketplace in which the seller is selling.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_scheduled_package(amazon_order_id, marketplace_id, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/package"
        params = {
          "amazonOrderId" => amazon_order_id,
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::EasyShip20220323::Package if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Schedules an Easy Ship order and returns the scheduled package information.
      #
      # This operation does the following:
      #
      # * Specifies the time slot and handover method for the order to be scheduled for delivery.
      #
      # * Updates the Easy Ship order status.
      #
      # * Generates a shipping label and an invoice. Calling `createScheduledPackage` also generates a warranty document
      # if you specify a `SerialNumber` value. To get these documents, see
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide How to get invoice,
      # shipping label, and warranty documents}.
      #
      # * Shows the status of Easy Ship orders when you call the `getOrders` operation of the Selling Partner API for
      # Orders and examine the `EasyShipShipmentStatus` property in the response body.
      #
      # See the **Shipping Label**, **Invoice**, and **Warranty** columns in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table} to see which documents are supported in each marketplace.
      #
      # @note This operation can make a static sandbox call.
      # @param create_scheduled_package_request [Hash] The request schema for the `createScheduledPackage` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_scheduled_package(create_scheduled_package_request, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/package"
        body = create_scheduled_package_request
        parser = Peddler::Types::EasyShip20220323::Package if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Updates the time slot for handing over the package indicated by the specified `scheduledPackageId`. You can get
      # the new `slotId` value for the time slot by calling the `listHandoverSlots` operation before making another
      # `patch` call.
      #
      # See the **Update Package** column in the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # Marketplace Support Table} to see which marketplaces this operation is supported in.
      #
      # @note This operation can make a static sandbox call.
      # @param update_scheduled_packages_request [Hash] The request schema for the `updateScheduledPackages` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_scheduled_packages(update_scheduled_packages_request: nil, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/package"
        body = update_scheduled_packages_request
        parser = Peddler::Types::EasyShip20220323::Packages if typed?
        meter(rate_limit).patch(path, body:, parser:)
      end

      # This operation automatically schedules a time slot for all the `amazonOrderId`s given as input, generating the
      # associated shipping labels, along with other compliance documents according to the marketplace (refer to the
      # {https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support-table
      # marketplace document support table}).
      #
      # Developers calling this operation may optionally assign a `packageDetails` object, allowing them to input a
      # preferred time slot for each order in ther request. In this case, Amazon will try to schedule the respective
      # packages using their optional settings. On the other hand, *i.e.*, if the time slot is not provided, Amazon will
      # then pick the earliest time slot possible.
      #
      # Regarding the shipping label's file format, external developers are able to choose between PDF or ZPL, and
      # Amazon will create the label accordingly.
      #
      # This operation returns an array composed of the scheduled packages, and a short-lived URL pointing to a zip file
      # containing the generated shipping labels and the other documents enabled for your marketplace. If at least an
      # order couldn't be scheduled, then Amazon adds the `rejectedOrders` list into the response, which contains an
      # entry for each order we couldn't process. Each entry is composed of an error message describing the reason of
      # the failure, so that sellers can take action.
      #
      # The table below displays the supported request and burst maximum rates:
      #
      # @note This operation can make a static sandbox call.
      # @param create_scheduled_packages_request [Hash] The request schema for the `createScheduledPackageBulk`
      #   operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_scheduled_package_bulk(create_scheduled_packages_request, rate_limit: 1.0)
        path = "/easyShip/2022-03-23/packages/bulk"
        body = create_scheduled_packages_request
        parser = Peddler::Types::EasyShip20220323::CreateScheduledPackagesResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end
    end
  end
end
