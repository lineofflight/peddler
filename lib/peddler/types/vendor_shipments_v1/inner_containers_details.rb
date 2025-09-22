# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/container_sequence_numbers"

module Peddler
  module Types
    module VendorShipmentsV1
      # Details of the innerContainersDetails.
      InnerContainersDetails = Structure.new do
        # @return [Integer] Total containers as part of the shipment
        attribute(:container_count, Integer, from: "containerCount")

        # @return [Array<ContainerSequenceNumbers>] Container sequence numbers that are involved in this shipment.
        attribute(:container_sequence_numbers, [ContainerSequenceNumbers], from: "containerSequenceNumbers")
      end
    end
  end
end
