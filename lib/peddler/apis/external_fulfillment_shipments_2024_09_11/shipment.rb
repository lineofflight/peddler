# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about a shipment.
      Shipment = Structure.new do
        # @return [Array<Charge>] The charges associated with the shipment. The charge amount does not include the tax
        #   amount.
        attribute(:charges, [Charge])

        # @return [String] The date and time when the shipment was created.
        attribute(:creation_date_time, String, from: "creationDateTime")

        # @return [String] The shipment's ID.
        attribute(:id, String)

        # @return [String] The date and time when the shipment was last updated.
        attribute(:last_updated_date_time, String, from: "lastUpdatedDateTime")

        # @return [Array<ShipmentLineItem>] The line items in the shipment.
        attribute(:line_items, [ShipmentLineItem], from: "lineItems")

        # @return [String] The location identifier of the seller's location in the marketplace channel to which the
        #   shipment has been created for fulfillment.
        attribute(:location_id, String, from: "locationId")

        # @return [MarketplaceAttributes] The marketplace attributes from which the shipment has been created for
        #   fulfillment.
        attribute(:marketplace_attributes, MarketplaceAttributes, from: "marketplaceAttributes")

        # @return [ShipmentInfo] High-level details of the shipment.
        attribute(:shipment_info, ShipmentInfo, from: "shipmentInfo")

        # @return [ShipmentRequirements] Whether a specific capabilities are enabled/required for the shipment.
        attribute(:shipment_requirements, ShipmentRequirements, from: "shipmentRequirements")

        # @return [ShippingInfo] Shipping information for the packages in this shipment.
        attribute(:shipping_info, ShippingInfo, from: "shippingInfo")

        # @return [String] The current status of the shipment.
        attribute(:status, String)

        # @return [String] The time when the shipment becomes eligible for processing.
        attribute?(:earliest_pack_date_time, String, from: "earliestPackDateTime")

        # @return [InvoiceInfo] Information about the shipment's invoice.
        attribute?(:invoice_info, InvoiceInfo, from: "invoiceInfo")

        # @return [Array<Package>] The list of packages in the shipment.
        attribute?(:packages, [Package])

        # @return [Array<PartyIdentificationInfo>] All involved party identification and metadata for vendor, buyer,
        #   seller. Applicable for direct-fulfillment sellers.
        attribute?(:party_info_list, [PartyIdentificationInfo], from: "partyInfoList")

        # @return [String] The sub status of the shipment.
        attribute?(:sub_status, String, from: "subStatus")
      end
    end
  end
end
