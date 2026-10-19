# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Information about a shipment.
      Shipment = Structure.new do
        # The charges associated with the shipment. The charge amount does not include the tax amount.
        attribute(:charges, [Charge], null: false)

        # The date and time when the shipment was created.
        attribute(:creation_date_time, String, null: false, from: "creationDateTime")

        # The shipment's ID.
        attribute(:id, String, null: false)

        # The date and time when the shipment was last updated.
        attribute(:last_updated_date_time, String, null: false, from: "lastUpdatedDateTime")

        # The line items in the shipment.
        attribute(:line_items, [ShipmentLineItem], null: false, from: "lineItems")

        # The location identifier of the seller's location in the marketplace channel to which the shipment has been
        # created for fulfillment.
        attribute(:location_id, String, null: false, from: "locationId")

        # The marketplace attributes from which the shipment has been created for fulfillment.
        attribute(:marketplace_attributes, MarketplaceAttributes, null: false, from: "marketplaceAttributes")

        # High-level details of the shipment.
        attribute(:shipment_info, ShipmentInfo, null: false, from: "shipmentInfo")

        # Whether a specific capabilities are enabled/required for the shipment.
        attribute(:shipment_requirements, ShipmentRequirements, null: false, from: "shipmentRequirements")

        # Shipping information for the packages in this shipment.
        attribute(:shipping_info, ShippingInfo, null: false, from: "shippingInfo")

        # The current status of the shipment. Known values: `CREATED`, `ACCEPTED`, `CONFIRMED`, `PACKAGE_CREATED`,
        # `PICKUP_SLOT_RETRIEVED`, `INVOICE_GENERATED`, `SHIPLABEL_GENERATED`, `CANCELLED`, `SHIPPED`, `DELIVERED`.
        attribute(:status, String, null: false)

        # The time when the shipment becomes eligible for processing.
        attribute?(:earliest_pack_date_time, String, from: "earliestPackDateTime")

        # Information about the shipment's invoice.
        attribute?(:invoice_info, InvoiceInfo, from: "invoiceInfo")

        # The list of packages in the shipment.
        attribute?(:packages, [Package])

        # All involved party identification and metadata for vendor, buyer, seller. Applicable for direct-fulfillment
        # sellers.
        attribute?(:party_info_list, [PartyIdentificationInfo], from: "partyInfoList")

        # The reason for the sub-status.
        attribute?(:reason, String)

        # The sub status of the shipment. Known values: `PENDING_SCHEDULE`, `PENDING_PICKUP`, `PENDING_DROP_OFF`,
        # `LABEL_CANCELED`, `PICKED_UP`, `DROPPED_OFF`, `AT_ORIGIN_FC`, `AT_DESTINATION_FC`, `DELIVERED`,
        # `NOT_DELIVERED`, `UNDELIVERABLE`, `LOST`, `OUT_FOR_DELIVERY`, `DAMAGED`.
        attribute?(:sub_status, String, from: "subStatus")
      end
    end
  end
end
