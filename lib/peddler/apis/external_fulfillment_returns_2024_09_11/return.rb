# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentReturns20240911
      # Information about the return item.
      Return = Structure.new do
        # @return [String] The ID of the location that fulfilled the order.
        attribute(:fulfillment_location_id, String, from: "fulfillmentLocationId")

        # @return [String] The return item's ID.
        attribute(:id, String)

        # @return [String] The date and time of the most recent update to the return.
        attribute(:last_updated_date_time, String, from: "lastUpdatedDateTime")

        # @return [MarketplaceChannelDetails] Channel-specific attributes for the return. These attributes are not
        #   mandatory and each channel can provide them differently.
        attribute(:marketplace_channel_details, MarketplaceChannelDetails, from: "marketplaceChannelDetails")

        # @return [ReturnMetadata] Metadata about the return item.
        attribute(:return_metadata, ReturnMetadata, from: "returnMetadata")

        # @return [ReturnShippingInfo] Information about the shipping of the return packages.
        attribute(:return_shipping_info, ReturnShippingInfo, from: "returnShippingInfo")

        # @return [String] The type of return.
        attribute(:return_type, String, from: "returnType")

        # @return [String] The current status of the return.
        attribute(:status, String)

        # @return [String] The date and time when the return was created.
        attribute?(:creation_date_time, String, from: "creationDateTime")

        # @return [String] The seller's identifier for the SKU.
        attribute?(:merchant_sku, String, from: "merchantSku")

        # @return [Integer] The total number of units in the return.
        attribute?(:number_of_units, Integer, from: "numberOfUnits")

        # @return [OtpDetails] The one-time password (OTP) details of the return item.
        attribute?(:otp_details, OtpDetails, from: "otpDetails")

        # @return [String] The package delivery mode. This indicates whether the return was delivered to the seller with
        #   or without a one-time password (OTP).
        attribute?(:package_delivery_mode, String, from: "packageDeliveryMode")

        # @return [ReplanningDetails] Details about the replanned returns.
        attribute?(:replanning_details, ReplanningDetails, from: "replanningDetails")

        # @return [String] The SmartConnect identifier for where the return item was dropped for delivery.
        attribute?(:return_location_id, String, from: "returnLocationId")

        # @return [String] The sub-type of return.
        attribute?(:return_sub_type, String, from: "returnSubType")
      end
    end
  end
end
