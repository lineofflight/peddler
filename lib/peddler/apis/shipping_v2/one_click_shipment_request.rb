# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for the OneClickShipment operation. When the channelType is not Amazon, shipTo is required
      # and when channelType is Amazon shipTo is ignored.
      OneClickShipmentRequest = Structure.new do
        attribute(:channel_details, ChannelDetails, null: false, from: "channelDetails")

        attribute(:label_specifications, RequestedDocumentSpecification, null: false, from: "labelSpecifications")

        attribute(:packages, [Package], null: false)

        attribute(:service_selection, ServiceSelection, null: false, from: "serviceSelection")

        # The ship from address.
        attribute(:ship_from, Address, null: false, from: "shipFrom")

        attribute?(:destination_access_point_details, AccessPointDetails, from: "destinationAccessPointDetails")

        # The seller owning the goods before handing them over to the carrier
        attribute?(:goods_owner, GoodsOwner, from: "goodsOwner")

        # The return to address.
        attribute?(:return_to, Address, from: "returnTo")

        # The ship date and time (the requested pickup). This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")

        # The ship to address.
        attribute?(:ship_to, Address, from: "shipTo")

        # Optional field for shipper instruction.
        attribute?(:shipper_instruction, ShipperInstruction, from: "shipperInstruction")

        attribute?(:tax_details, [TaxDetail], from: "taxDetails")

        attribute?(:value_added_services_details, [OneClickShipmentValueAddedService], from: "valueAddedServicesDetails")
      end
    end
  end
end
