# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Container sequence numbers that are involved in this shipment.
      ContainerSequenceNumbers = Structure.new do
        # @return [String] A list of containers shipped
        attribute?(:container_sequence_number, String, from: "containerSequenceNumber")
      end
    end
  end
end
