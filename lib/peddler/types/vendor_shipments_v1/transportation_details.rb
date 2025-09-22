# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/carrier_details"

module Peddler
  module Types
    module VendorShipmentsV1
      # Transportation details for this shipment.
      TransportationDetails = Structure.new do
        # @return [String] The type of shipment.
        attribute(:ship_mode, String, from: "shipMode")

        # @return [String] The mode of transportation for this shipment.
        attribute(:transportation_mode, String, from: "transportationMode")

        # @return [String] Date when shipment is performed by the Vendor to Buyer
        attribute(:shipped_date, String, from: "shippedDate")

        # @return [String] Estimated Date on which shipment will be delivered from Vendor to Buyer
        attribute(:estimated_delivery_date, String, from: "estimatedDeliveryDate")

        # @return [String] Date on which shipment will be delivered from Vendor to Buyer
        attribute(:shipment_delivery_date, String, from: "shipmentDeliveryDate")

        # @return [CarrierDetails] Indicates the carrier details and their contact informations
        attribute(:carrier_details, CarrierDetails, from: "carrierDetails")

        # @return [String] The Bill of Lading (BOL) number is a unique number assigned to each shipment of goods by the
        # vendor or shipper during the creation of the Bill of Lading. This number must be unique for every shipment and
        # cannot be a date/time or single character. The BOL numer is mandatory in Shipment Confirmation message for FTL
        # and LTL shipments, and must match the paper BOL provided with the shipment. Instead of BOL, an alternative
        # reference number (like Delivery Note Number) for the shipment can also be sent in this field.
        attribute(:bill_of_lading_number, String, from: "billOfLadingNumber")
      end
    end
  end
end
