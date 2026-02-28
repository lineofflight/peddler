# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The transportation option selected to confirm.
      TransportationSelection = Structure.new do
        # @return [String] Shipment ID that the transportation Option is for.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String] Transportation option being selected for the provided shipment.
        attribute(:transportation_option_id, String, null: false, from: "transportationOptionId")

        # @return [ContactInformation]
        attribute?(:contact_information, ContactInformation, from: "contactInformation")
      end
    end
  end
end
