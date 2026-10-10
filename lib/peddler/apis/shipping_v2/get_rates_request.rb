# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for the getRates operation. When the channelType is Amazon, the shipTo address is not
      # required and will be ignored.
      GetRatesRequest = Structure.new do
        attribute(:channel_details, ChannelDetails, null: false, from: "channelDetails")

        attribute(:packages, [Package], null: false)

        # The ship from address.
        attribute(:ship_from, Address, null: false, from: "shipFrom")

        attribute?(:carrier_accounts, [CarrierAccount], from: "carrierAccounts")

        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        attribute?(:destination_access_point_details, AccessPointDetails, from: "destinationAccessPointDetails")

        # The return to address.
        attribute?(:return_to, Address, from: "returnTo")

        # The ship date and time (the requested pickup). This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")

        # The ship to address.
        attribute?(:ship_to, Address, from: "shipTo")

        attribute?(:shipment_type, String, from: "shipmentType")

        # This field describe shipper instruction.
        attribute?(:shipper_instruction, ShipperInstruction, from: "shipperInstruction")

        attribute?(:tax_details, [TaxDetail], from: "taxDetails")

        attribute?(:value_added_services, ValueAddedServiceDetails, from: "valueAddedServices")
      end
    end
  end
end
