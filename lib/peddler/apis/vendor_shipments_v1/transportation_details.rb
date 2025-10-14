# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Transportation details for this shipment.
      TransportationDetails = Structure.new do
        # @return [String] The Bill of Lading (BOL) number is a unique number assigned to each shipment of goods by the
        # vendor or shipper during the creation of the Bill of Lading. This number must be unique for every shipment and
        # cannot be a date/time or single character. The BOL numer is mandatory in Shipment Confirmation message for FTL
        # and LTL shipments, and must match the paper BOL provided with the shipment. Instead of BOL, an alternative
        # reference number (like Delivery Note Number) for the shipment can also be sent in this field.
        attribute?(:bill_of_lading_number, String, from: "billOfLadingNumber")

        # @return [CarrierDetails] Indicates the carrier details and their contact informations
        attribute?(:carrier_details, CarrierDetails, from: "carrierDetails")

        # @return [Time] Estimated Date on which shipment will be delivered from Vendor to Buyer
        attribute?(:estimated_delivery_date, Time, from: "estimatedDeliveryDate")

        # @return [String] The type of shipment.
        attribute?(:ship_mode, String, from: "shipMode")

        # @return [Time] Date on which shipment will be delivered from Vendor to Buyer
        attribute?(:shipment_delivery_date, Time, from: "shipmentDeliveryDate")

        # @return [Time] Date when shipment is performed by the Vendor to Buyer
        attribute?(:shipped_date, Time, from: "shippedDate")

        # @return [String] The mode of transportation for this shipment.
        attribute?(:transportation_mode, String, from: "transportationMode")
      end
    end
  end
end
