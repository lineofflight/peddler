# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/channel_details"
require "peddler/types/shipping_v2/package"
require "peddler/types/shipping_v2/address"
require "peddler/types/shipping_v2/carrier_account"
require "peddler/types/shipping_v2/client_reference_detail"
require "peddler/types/shipping_v2/access_point_details"
require "peddler/types/shipping_v2/shipper_instruction"
require "peddler/types/shipping_v2/tax_detail"
require "peddler/types/shipping_v2/value_added_service_details"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the getRates operation. When the channelType is Amazon, the shipTo address is not
      # required and will be ignored.
      GetRatesRequest = Structure.new do
        # @return [ChannelDetails]
        attribute(:channel_details, ChannelDetails, from: "channelDetails")

        # @return [Array<Package>]
        attribute(:packages, [Package])

        # @return [Address] The ship from address.
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Array<CarrierAccount>]
        attribute?(:carrier_accounts, [CarrierAccount], from: "carrierAccounts")

        # @return [Array<ClientReferenceDetail>]
        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [AccessPointDetails]
        attribute?(:destination_access_point_details, AccessPointDetails, from: "destinationAccessPointDetails")

        # @return [Address] The return to address.
        attribute?(:return_to, Address, from: "returnTo")

        # @return [String] The ship date and time (the requested pickup). This defaults to the current date and time.
        attribute?(:ship_date, String, from: "shipDate")

        # @return [Address] The ship to address.
        attribute?(:ship_to, Address, from: "shipTo")

        # @return [String]
        attribute?(:shipment_type, String, from: "shipmentType")

        # @return [ShipperInstruction] This field describe shipper instruction.
        attribute?(:shipper_instruction, ShipperInstruction, from: "shipperInstruction")

        # @return [Array<TaxDetail>]
        attribute?(:tax_details, [TaxDetail], from: "taxDetails")

        # @return [ValueAddedServiceDetails]
        attribute?(:value_added_services, ValueAddedServiceDetails, from: "valueAddedServices")
      end
    end
  end
end
