# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The transportation option selected to confirm.
      TransportationSelection = Structure.new do
        # Shipment ID that the transportation Option is for.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # Transportation option being selected for the provided shipment.
        attribute(:transportation_option_id, String, null: false, from: "transportationOptionId")

        attribute?(:contact_information, ContactInformation, from: "contactInformation")
      end
    end
  end
end
