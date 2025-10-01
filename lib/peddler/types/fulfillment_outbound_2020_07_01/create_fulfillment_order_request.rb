# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/address"
require "peddler/types/fulfillment_outbound_2020_07_01/create_fulfillment_order_item"
require "peddler/types/fulfillment_outbound_2020_07_01/cod_settings"
require "peddler/types/fulfillment_outbound_2020_07_01/delivery_preferences"
require "peddler/types/fulfillment_outbound_2020_07_01/delivery_window"
require "peddler/types/fulfillment_outbound_2020_07_01/feature_settings"
require "peddler/types/fulfillment_outbound_2020_07_01/payment_information"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The request body schema for the `createFulfillmentOrder` operation.
      CreateFulfillmentOrderRequest = Structure.new do
        # @return [Address] The destination address for the fulfillment order.
        attribute(:destination_address, Address, from: "destinationAddress")

        # @return [String] Order-specific text that appears in recipient-facing materials such as the outbound shipment
        # packing slip.
        attribute(:displayable_order_comment, String, from: "displayableOrderComment")

        # @return [String] The date and time of the fulfillment order. Displays as the order date in recipient-facing
        # materials such as the outbound shipment packing slip.
        attribute(:displayable_order_date, String, from: "displayableOrderDate")

        # @return [String] A fulfillment order identifier that the seller creates. This value displays as the order
        # identifier in recipient-facing materials such as the outbound shipment packing slip. The value of
        # `displayableOrderId` should match the order identifier that the seller provides to the recipient. The seller
        # can use the SellerFulfillmentOrderId for this value or they can specify an alternate value if they want the
        # recipient to reference an alternate order identifier.
        #
        # The value must be an alpha-numeric or ISO 8859-1 compliant string from one to 40 characters in length. Cannot
        # contain two spaces in a row. Leading and trailing white space is removed.
        attribute(:displayable_order_id, String, from: "displayableOrderId")

        # @return [Array<CreateFulfillmentOrderItem>] A list of items to include in the fulfillment order preview,
        # including quantity. Maximum of 100 line items with a maximum of 250 units per order.
        attribute(:items, [CreateFulfillmentOrderItem])

        # @return [String] A fulfillment order identifier that the seller creates to track their fulfillment order. The
        # `sellerFulfillmentOrderId` must be unique for each fulfillment order that a seller creates. If the seller's
        # system already creates unique order identifiers, then these might be good values for them to use.
        attribute(:seller_fulfillment_order_id, String, from: "sellerFulfillmentOrderId")

        # @return [String] The shipping method for the fulfillment order. When this value is `ScheduledDelivery`, choose
        # Ship for the `fulfillmentAction`. Hold is not a valid `fulfillmentAction` value when the
        # `shippingSpeedCategory` value is `ScheduledDelivery`.
        # Note: Shipping method service level agreements vary by marketplace. Sellers can refer to [Seller Central](
        # https://developer-docs.amazon.com/sp-api/docs/seller-central-urls) for shipping method service-level
        # agreements and multi-channel fulfillment fees.
        attribute(:shipping_speed_category, String, from: "shippingSpeedCategory")

        # @return [CODSettings]
        attribute?(:cod_settings, CODSettings, from: "codSettings")

        # @return [DeliveryPreferences] The delivery preferences applied to the destination address. These preferences
        # are applied when possible and are best effort. For eligible orders, the default delivery preference is to
        # leave the package unattended at the front door.
        # This feature is currently supported only in the JP marketplace and not applicable for other marketplaces.
        # For eligible orders, the default delivery preference will be to deliver the package unattended at the front
        # door, unless you specify otherwise.
        attribute?(:delivery_preferences, DeliveryPreferences, from: "deliveryPreferences")

        # @return [DeliveryWindow]
        attribute?(:delivery_window, DeliveryWindow, from: "deliveryWindow")

        # @return [Array<FeatureSettings>] A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        # @return [String]
        attribute?(:fulfillment_action, String, from: "fulfillmentAction")

        # @return [String]
        attribute?(:fulfillment_policy, String, from: "fulfillmentPolicy")

        # @return [String] The marketplace the fulfillment order is placed against.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<String>]
        attribute?(:notification_emails, [String], from: "notificationEmails")

        # @return [Array<PaymentInformation>] An array of various payment attributes related to this fulfillment order.
        # This property is required if the order is placed against the India marketplace.
        attribute?(:payment_information, [PaymentInformation], from: "paymentInformation")

        # @return [String] The two-character country code for the country from which the fulfillment order ships. Must
        # be in ISO 3166-1 alpha-2 format.
        attribute?(:ship_from_country_code, String, from: "shipFromCountryCode")
      end
    end
  end
end
