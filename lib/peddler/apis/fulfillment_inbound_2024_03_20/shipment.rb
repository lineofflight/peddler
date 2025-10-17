# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains information pertaining to a shipment in an inbound plan.
      Shipment = Structure.new do
        # @return [ShipmentDestination]
        attribute(:destination, ShipmentDestination)

        # @return [String] The identifier of a placement option. A placement option represents the shipment splits and
        #   destinations of SKUs.
        attribute(:placement_option_id, String, from: "placementOptionId")

        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [ShipmentSource]
        attribute(:source, ShipmentSource)

        # @return [String] A unique identifier created by Amazon that identifies this Amazon-partnered, Less Than
        #   Truckload/Full Truckload (LTL/FTL) shipment.
        attribute?(:amazon_reference_id, String, from: "amazonReferenceId")

        # @return [ContactInformation]
        attribute?(:contact_information, ContactInformation, from: "contactInformation")

        # @return [Dates]
        attribute?(:dates, Dates)

        # @return [FreightInformation]
        attribute?(:freight_information, FreightInformation, from: "freightInformation")

        # @return [String] The name of the shipment.
        attribute?(:name, String)

        # @return [SelectedDeliveryWindow]
        attribute?(:selected_delivery_window, SelectedDeliveryWindow, from: "selectedDeliveryWindow")

        # @return [String] Identifier of a transportation option. A transportation option represent one option for how
        #   to send a shipment.
        attribute?(:selected_transportation_option_id, String, from: "selectedTransportationOptionId")

        # @return [Array<SelfShipAppointmentDetails>] List of self ship appointment details.
        attribute?(:self_ship_appointment_details, [SelfShipAppointmentDetails], from: "selfShipAppointmentDetails")

        # @return [String] The confirmed shipment ID which shows up on labels (for example, `FBA1234ABCD`).
        attribute?(:shipment_confirmation_id, String, from: "shipmentConfirmationId")

        # @return [String] The status of a shipment. The state of the shipment will typically start as `UNCONFIRMED`,
        #   then transition to `WORKING` after a placement option has been confirmed, and then to `READY_TO_SHIP` once
        #   labels are generated.
        #
        # Possible values: `ABANDONED`, `CANCELLED`, `CHECKED_IN`, `CLOSED`, `DELETED`, `DELIVERED`, `IN_TRANSIT`,
        #   `MIXED`, `READY_TO_SHIP`, `RECEIVING`, `SHIPPED`, `UNCONFIRMED`, `WORKING`
        attribute?(:status, String)

        # @return [TrackingDetails]
        attribute?(:tracking_details, TrackingDetails, from: "trackingDetails")
      end
    end
  end
end
