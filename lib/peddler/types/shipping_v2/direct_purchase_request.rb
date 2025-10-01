# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/channel_details"
require "peddler/types/shipping_v2/requested_document_specification"
require "peddler/types/shipping_v2/package"
require "peddler/types/shipping_v2/address"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the directPurchaseShipment operation. When the channel type is Amazon, the shipTo address
      # is not required and will be ignored.
      DirectPurchaseRequest = Structure.new do
        # @return [ChannelDetails]
        attribute(:channel_details, ChannelDetails, from: "channelDetails")

        # @return [RequestedDocumentSpecification] The document (label) specifications requested. The default label
        # returned is PNG DPI 203 4x6 if no label specification is provided. Requesting an invalid file format results
        # in a failure.
        attribute?(:label_specifications, RequestedDocumentSpecification, from: "labelSpecifications")

        # @return [Array<Package>]
        attribute?(:packages, [Package])

        # @return [Address] The address where the package will be returned if it cannot be delivered.
        attribute?(:return_to, Address, from: "returnTo")

        # @return [Address] The address where the package will be picked up.
        attribute?(:ship_from, Address, from: "shipFrom")

        # @return [Address] The address where the shipment will be delivered. For vendor orders, shipTo information is
        # pulled directly from the Amazon order.
        attribute?(:ship_to, Address, from: "shipTo")
      end
    end
  end
end
