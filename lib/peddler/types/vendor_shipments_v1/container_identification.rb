# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # A list of carton identifiers.
      ContainerIdentification = Structure.new do
        # @return [String] Container identification number that adheres to the definition of the container
        # identification type.
        attribute(:container_identification_number, String, from: "containerIdentificationNumber")

        # @return [String] The container identification type.
        attribute(:container_identification_type, String, from: "containerIdentificationType")
      end
    end
  end
end
