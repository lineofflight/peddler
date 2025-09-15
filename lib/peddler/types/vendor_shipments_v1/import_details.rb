# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/route"
require "peddler/types/vendor_shipments_v1/weight"

module Peddler
  module Types
    module VendorShipmentsV1
      # Provide these fields only if this shipment is a direct import.
      ImportDetails = Structure.new do
        # @return [String] This is used for import purchase orders only. If the recipient requests, this field will
        # contain the shipment method of payment.
        attribute(:method_of_payment, String, from: "methodOfPayment")

        # @return [String] The container's seal number.
        attribute(:seal_number, String, from: "sealNumber")

        # @return [Route] The route and stop details for this shipment.
        attribute(:route, Route)

        # @return [String] Types and numbers of container(s) for import purchase orders. Can be a comma-separated list
        # if shipment has multiple containers.
        attribute(:import_containers, String, from: "importContainers")

        # @return [Weight] Billable weight of the direct imports shipment.
        attribute(:billable_weight, Weight, from: "billableWeight")

        # @return [String] Date on which the shipment is expected to be shipped. This value should not be in the past
        # and not more than 60 days out in the future.
        attribute(:estimated_ship_by_date, String, from: "estimatedShipByDate")

        # @return [String] Identification of the instructions on how specified item/carton/pallet should be handled.
        attribute(:handling_instructions, String, from: "handlingInstructions")
      end
    end
  end
end
