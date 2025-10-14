# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
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

        # @return [Time] The ship date and time (the requested pickup). This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")

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
