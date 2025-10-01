# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/channel_details"
require "peddler/types/shipping_v2/requested_document_specification"
require "peddler/types/shipping_v2/package"
require "peddler/types/shipping_v2/service_selection"
require "peddler/types/shipping_v2/address"
require "peddler/types/shipping_v2/access_point_details"
require "peddler/types/shipping_v2/goods_owner"
require "peddler/types/shipping_v2/shipper_instruction"
require "peddler/types/shipping_v2/tax_detail"
require "peddler/types/shipping_v2/one_click_shipment_value_added_service"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the OneClickShipment operation. When the channelType is not Amazon, shipTo is required
      # and when channelType is Amazon shipTo is ignored.
      OneClickShipmentRequest = Structure.new do
        # @return [ChannelDetails]
        attribute(:channel_details, ChannelDetails, from: "channelDetails")

        # @return [RequestedDocumentSpecification]
        attribute(:label_specifications, RequestedDocumentSpecification, from: "labelSpecifications")

        # @return [Array<Package>]
        attribute(:packages, [Package])

        # @return [ServiceSelection]
        attribute(:service_selection, ServiceSelection, from: "serviceSelection")

        # @return [Address] The ship from address.
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [AccessPointDetails]
        attribute?(:destination_access_point_details, AccessPointDetails, from: "destinationAccessPointDetails")

        # @return [GoodsOwner] The seller owning the goods before handing them over to the carrier
        attribute?(:goods_owner, GoodsOwner, from: "goodsOwner")

        # @return [Address] The return to address.
        attribute?(:return_to, Address, from: "returnTo")

        # @return [String] The ship date and time (the requested pickup). This defaults to the current date and time.
        attribute?(:ship_date, String, from: "shipDate")

        # @return [Address] The ship to address.
        attribute?(:ship_to, Address, from: "shipTo")

        # @return [ShipperInstruction] Optional field for shipper instruction.
        attribute?(:shipper_instruction, ShipperInstruction, from: "shipperInstruction")

        # @return [Array<TaxDetail>]
        attribute?(:tax_details, [TaxDetail], from: "taxDetails")

        # @return [Array<OneClickShipmentValueAddedService>]
        attribute?(:value_added_services_details, [OneClickShipmentValueAddedService], from: "valueAddedServicesDetails")
      end
    end
  end
end
