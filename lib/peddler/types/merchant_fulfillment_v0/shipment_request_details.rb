# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/item"
require "peddler/types/merchant_fulfillment_v0/address"
require "peddler/types/merchant_fulfillment_v0/package_dimensions"
require "peddler/types/merchant_fulfillment_v0/weight"
require "peddler/types/merchant_fulfillment_v0/shipping_service_options"
require "peddler/types/merchant_fulfillment_v0/label_customization"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Shipment information required for requesting shipping service offers or for creating a shipment.
      ShipmentRequestDetails = Structure.new do
        # @return [String] An Amazon-defined order identifier in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] A seller-defined order identifier.
        attribute(:seller_order_id, String, from: "SellerOrderId")

        # @return [Array<Item>]
        attribute(:item_list, [Item], from: "ItemList")

        # @return [Address] The address of the sender.
        attribute(:ship_from_address, Address, from: "ShipFromAddress")

        # @return [PackageDimensions] The package dimensions.
        attribute(:package_dimensions, PackageDimensions, from: "PackageDimensions")

        # @return [Weight] The package weight.
        attribute(:weight, Weight, from: "Weight")

        # @return [String] The date by which the package must arrive to keep the promise to the customer, in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. If `MustArriveByDate` is
        # specified, only shipping service offers that can be delivered by that date are returned.
        attribute(:must_arrive_by_date, String, from: "MustArriveByDate")

        # @return [String] When used in a request, this is the date and time that the seller wants to ship the package.
        # When used in a response, this is the date and time that the package can be shipped by the indicated method.
        attribute(:ship_date, String, from: "ShipDate")

        # @return [ShippingServiceOptions] Extra services offered by the carrier.
        attribute(:shipping_service_options, ShippingServiceOptions, from: "ShippingServiceOptions")

        # @return [LabelCustomization] Label customization options.
        attribute(:label_customization, LabelCustomization, from: "LabelCustomization")
      end
    end
  end
end
