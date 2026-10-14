# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentReturns20240911
      # Information about the return item.
      Return = Structure.new do
        # @return [String] The ID of the location that fulfilled the order.
        attribute(:fulfillment_location_id, String, null: false, from: "fulfillmentLocationId")

        # @return [String] The return item's ID.
        attribute(:id, String, null: false)

        # @return [String] The date and time of the most recent update to the return.
        attribute(:last_updated_date_time, String, null: false, from: "lastUpdatedDateTime")

        # @return [MarketplaceChannelDetails] Channel-specific attributes for the return. These attributes are not
        #   mandatory and each channel can provide them differently.
        attribute(:marketplace_channel_details, MarketplaceChannelDetails, null: false, from: "marketplaceChannelDetails")

        # @return [ReturnMetadata] Metadata about the return item.
        attribute(:return_metadata, ReturnMetadata, null: false, from: "returnMetadata")

        # @return [ReturnShippingInfo] Information about the shipping of the return packages.
        attribute(:return_shipping_info, ReturnShippingInfo, null: false, from: "returnShippingInfo")

        # @return [String] The type of return. Known values: `CUSTOMER`, `REJECT`.
        attribute(:return_type, String, null: false, from: "returnType")

        # @return [String] The current status of the return. Known values: `CREATED`,
        #   `CARRIER_NOTIFIED_TO_PICK_UP_FROM_CUSTOMER`, `CARRIER_OUT_FOR_PICK_UP_FROM_CUSTOMER`,
        #   `CUSTOMER_CANCELLED_PICK_UP`, `CUSTOMER_RESCHEDULED_PICK_UP`, `PICKED_FROM_CUSTOMER`, `IN_TRANSIT`,
        #   `OUT_FOR_DELIVERY`, `DELIVERED`, `REPLANNED`, `CUSTOMER_DROPPED_OFF`, `PARTIALLY_PROCESSED`, `PROCESSED`,
        #   `REJECTED`, `CANCELLED`.
        attribute(:status, String, null: false)

        # @return [String] The date and time when the return was created.
        attribute?(:creation_date_time, String, from: "creationDateTime")

        # @return [String] The seller's identifier for the SKU.
        attribute?(:merchant_sku, String, from: "merchantSku")

        # @return [Integer] The total number of units in the return.
        attribute?(:number_of_units, Integer, from: "numberOfUnits")

        # @return [OtpDetails] The one-time password (OTP) details of the return item.
        attribute?(:otp_details, OtpDetails, from: "otpDetails")

        # @return [String] The package delivery mode. This indicates whether the return was delivered to the seller with
        #   or without a one-time password (OTP). Known values: `WITH_OTP`, `WITHOUT_OTP`.
        attribute?(:package_delivery_mode, String, from: "packageDeliveryMode")

        # @return [ReplanningDetails] Details about the replanned returns.
        attribute?(:replanning_details, ReplanningDetails, from: "replanningDetails")

        # @return [String] The SmartConnect identifier for where the return item was dropped for delivery.
        attribute?(:return_location_id, String, from: "returnLocationId")

        # @return [String] The sub-type of return. Known values: `NORMAL`, `REPLACEMENT`, `EXCHANGE`.
        attribute?(:return_sub_type, String, from: "returnSubType")
      end
    end
  end
end
