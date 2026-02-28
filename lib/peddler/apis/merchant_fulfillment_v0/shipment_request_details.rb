# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Shipment information required for requesting shipping service offers or for creating a shipment.
      ShipmentRequestDetails = Structure.new do
        # @return [String] An Amazon-defined order identifier in 3-7-7 format.
        attribute(:amazon_order_id, String, null: false, from: "AmazonOrderId")

        # @return [Array<Item>]
        attribute(:item_list, [Item], null: false, from: "ItemList")

        # @return [PackageDimensions] The package dimensions.
        attribute(:package_dimensions, PackageDimensions, null: false, from: "PackageDimensions")

        # @return [Address] The address of the sender.
        attribute(:ship_from_address, Address, null: false, from: "ShipFromAddress")

        # @return [ShippingServiceOptions] Extra services offered by the carrier.
        attribute(:shipping_service_options, ShippingServiceOptions, null: false, from: "ShippingServiceOptions")

        # @return [Weight] The package weight.
        attribute(:weight, Weight, null: false, from: "Weight")

        # @return [LabelCustomization] Label customization options.
        attribute?(:label_customization, LabelCustomization, from: "LabelCustomization")

        # @return [String] The date by which the package must arrive to keep the promise to the customer, in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. If `MustArriveByDate` is
        #   specified, only shipping service offers that can be delivered by that date are returned.
        attribute?(:must_arrive_by_date, String, from: "MustArriveByDate")

        # @return [String] A seller-defined order identifier.
        attribute?(:seller_order_id, String, from: "SellerOrderId")

        # @return [String] When used in a request, this is the date and time that the seller wants to ship the package.
        #   When used in a response, this is the date and time that the package can be shipped by the indicated method.
        attribute?(:ship_date, String, from: "ShipDate")
      end
    end
  end
end
