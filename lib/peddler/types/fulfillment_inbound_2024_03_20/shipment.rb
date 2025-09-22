# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/contact_information"
require "peddler/types/fulfillment_inbound_2024_03_20/dates"
require "peddler/types/fulfillment_inbound_2024_03_20/shipment_destination"
require "peddler/types/fulfillment_inbound_2024_03_20/freight_information"
require "peddler/types/fulfillment_inbound_2024_03_20/selected_delivery_window"
require "peddler/types/fulfillment_inbound_2024_03_20/self_ship_appointment_details"
require "peddler/types/fulfillment_inbound_2024_03_20/shipment_source"
require "peddler/types/fulfillment_inbound_2024_03_20/tracking_details"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information pertaining to a shipment in an inbound plan.
      Shipment = Structure.new do
        # @return [String] A unique identifier created by Amazon that identifies this Amazon-partnered, Less Than
        # Truckload/Full Truckload (LTL/FTL) shipment.
        attribute(:amazon_reference_id, String, from: "amazonReferenceId")

        # @return [ContactInformation]
        attribute(:contact_information, ContactInformation, from: "contactInformation")

        # @return [Dates]
        attribute(:dates, Dates)

        # @return [ShipmentDestination]
        attribute(:destination, ShipmentDestination)

        # @return [FreightInformation]
        attribute(:freight_information, FreightInformation, from: "freightInformation")

        # @return [String] The name of the shipment.
        attribute(:name, String)

        # @return [String] The identifier of a placement option. A placement option represents the shipment splits and
        # destinations of SKUs.
        attribute(:placement_option_id, String, from: "placementOptionId")

        # @return [SelectedDeliveryWindow]
        attribute(:selected_delivery_window, SelectedDeliveryWindow, from: "selectedDeliveryWindow")

        # @return [String] Identifier of a transportation option. A transportation option represent one option for how
        # to send a shipment.
        attribute(:selected_transportation_option_id, String, from: "selectedTransportationOptionId")

        # @return [Array<SelfShipAppointmentDetails>] List of self ship appointment details.
        attribute(:self_ship_appointment_details, [SelfShipAppointmentDetails], from: "selfShipAppointmentDetails")

        # @return [String] The confirmed shipment ID which shows up on labels (for example, `FBA1234ABCD`).
        attribute(:shipment_confirmation_id, String, from: "shipmentConfirmationId")

        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [ShipmentSource]
        attribute(:source, ShipmentSource)

        # @return [String] The status of a shipment. The state of the shipment will typically start as `UNCONFIRMED`,
        # then transition to `WORKING` after a placement option has been confirmed, and then to `READY_TO_SHIP` once
        # labels are generated.
        #
        # Possible values: `ABANDONED`, `CANCELLED`, `CHECKED_IN`, `CLOSED`, `DELETED`, `DELIVERED`, `IN_TRANSIT`,
        # `MIXED`, `READY_TO_SHIP`, `RECEIVING`, `SHIPPED`, `UNCONFIRMED`, `WORKING`
        attribute(:status, String)

        # @return [TrackingDetails]
        attribute(:tracking_details, TrackingDetails, from: "trackingDetails")
      end
    end
  end
end
