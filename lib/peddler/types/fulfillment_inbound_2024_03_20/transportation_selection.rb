# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/contact_information"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The transportation option selected to confirm.
      TransportationSelection = Structure.new do
        # @return [ContactInformation]
        attribute(:contact_information, ContactInformation, from: "contactInformation")

        # @return [String] Shipment ID that the transportation Option is for.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [String] Transportation option being selected for the provided shipment.
        attribute(:transportation_option_id, String, from: "transportationOptionId")
      end
    end
  end
end
