# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentReturns20240911
      # Information about the return item.
      Return = Structure.new do
        # The ID of the location that fulfilled the order.
        attribute(:fulfillment_location_id, String, null: false, from: "fulfillmentLocationId")

        # The return item's ID.
        attribute(:id, String, null: false)

        # The date and time of the most recent update to the return.
        attribute(:last_updated_date_time, String, null: false, from: "lastUpdatedDateTime")

        # Channel-specific attributes for the return. These attributes are not mandatory and each channel can provide
        # them differently.
        attribute(:marketplace_channel_details, MarketplaceChannelDetails, null: false, from: "marketplaceChannelDetails")

        # Metadata about the return item.
        attribute(:return_metadata, ReturnMetadata, null: false, from: "returnMetadata")

        # Information about the shipping of the return packages.
        attribute(:return_shipping_info, ReturnShippingInfo, null: false, from: "returnShippingInfo")

        # The type of return.
        attribute(:return_type, String, null: false, from: "returnType")

        # The current status of the return.
        attribute(:status, String, null: false)

        # The date and time when the return was created.
        attribute?(:creation_date_time, String, from: "creationDateTime")

        # The seller's identifier for the SKU.
        attribute?(:merchant_sku, String, from: "merchantSku")

        # The total number of units in the return.
        attribute?(:number_of_units, Integer, from: "numberOfUnits")

        # The one-time password (OTP) details of the return item.
        attribute?(:otp_details, OtpDetails, from: "otpDetails")

        # The package delivery mode. This indicates whether the return was delivered to the seller with or without a
        # one-time password (OTP).
        attribute?(:package_delivery_mode, String, from: "packageDeliveryMode")

        # Details about the replanned returns.
        attribute?(:replanning_details, ReplanningDetails, from: "replanningDetails")

        # The SmartConnect identifier for where the return item was dropped for delivery.
        attribute?(:return_location_id, String, from: "returnLocationId")

        # The sub-type of return.
        attribute?(:return_sub_type, String, from: "returnSubType")
      end
    end
  end
end
