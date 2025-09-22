# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/address"
require "peddler/types/fulfillment_inbound_v0/box_contents_fee_details"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Information about the seller's inbound shipments. Returned by the listInboundShipments operation.
      InboundShipmentInfo = Structure.new do
        # @return [String] The shipment identifier submitted in the request.
        attribute(:shipment_id, String, from: "ShipmentId")

        # @return [String] The name for the inbound shipment.
        attribute(:shipment_name, String, from: "ShipmentName")

        # @return [Address] The return address.
        attribute(:ship_from_address, Address, from: "ShipFromAddress")

        # @return [String] An Amazon fulfillment center identifier created by Amazon.
        attribute(:destination_fulfillment_center_id, String, from: "DestinationFulfillmentCenterId")

        # @return [String]
        attribute(:shipment_status, String, from: "ShipmentStatus")

        # @return [String]
        attribute(:label_prep_type, String, from: "LabelPrepType")

        # @return [:boolean] Indicates whether or not an inbound shipment contains case-packed boxes. When
        # AreCasesRequired = true for an inbound shipment, all items in the inbound shipment must be case packed.
        attribute(:are_cases_required, :boolean, from: "AreCasesRequired")

        # @return [String] Date by which the shipment must arrive at the Amazon fulfillment center to avoid delivery
        # promise breaks for pre-ordered items.
        attribute(:confirmed_need_by_date, String, from: "ConfirmedNeedByDate")

        # @return [String]
        attribute(:box_contents_source, String, from: "BoxContentsSource")

        # @return [BoxContentsFeeDetails] An estimate of the manual processing fee charged by Amazon for boxes without
        # box content information. This is only returned when BoxContentsSource is NONE.
        attribute(:estimated_box_contents_fee, BoxContentsFeeDetails, from: "EstimatedBoxContentsFee")
      end
    end
  end
end
