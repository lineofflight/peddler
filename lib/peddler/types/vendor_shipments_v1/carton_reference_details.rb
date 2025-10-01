# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Carton reference details.
      CartonReferenceDetails = Structure.new do
        # @return [Array<String>] Array of reference numbers for the carton that are part of this pallet/shipment.
        # Please provide the cartonSequenceNumber from the 'cartons' segment to refer to that carton's details here.
        attribute(:carton_reference_numbers, [String], from: "cartonReferenceNumbers")

        # @return [Integer] Pallet level carton count is mandatory for single item pallet and optional for mixed item
        # pallet.
        attribute?(:carton_count, Integer, from: "cartonCount")
      end
    end
  end
end
