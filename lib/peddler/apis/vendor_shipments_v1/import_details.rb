# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Provide these fields only if this shipment is a direct import.
      ImportDetails = Structure.new do
        # @return [Weight] Billable weight of the direct imports shipment.
        attribute?(:billable_weight, Weight, from: "billableWeight")

        # @return [Time] Date on which the shipment is expected to be shipped. This value should not be in the past and
        #   not more than 60 days out in the future.
        attribute?(:estimated_ship_by_date, Time, from: "estimatedShipByDate")

        # @return [String] Identification of the instructions on how specified item/carton/pallet should be handled.
        attribute?(:handling_instructions, String, from: "handlingInstructions")

        # @return [String] Types and numbers of container(s) for import purchase orders. Can be a comma-separated list
        #   if shipment has multiple containers.
        attribute?(:import_containers, String, from: "importContainers")

        # @return [String] This is used for import purchase orders only. If the recipient requests, this field will
        #   contain the shipment method of payment.
        attribute?(:method_of_payment, String, from: "methodOfPayment")

        # @return [Route] The route and stop details for this shipment.
        attribute?(:route, Route)

        # @return [String] The container's seal number.
        attribute?(:seal_number, String, from: "sealNumber")
      end
    end
  end
end
