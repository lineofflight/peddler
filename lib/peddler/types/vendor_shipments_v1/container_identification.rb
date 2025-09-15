# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # A list of carton identifiers.
      ContainerIdentification = Structure.new do
        # @return [String] The container identification type.
        attribute(:container_identification_type, String, from: "containerIdentificationType")

        # @return [String] Container identification number that adheres to the definition of the container
        # identification type.
        attribute(:container_identification_number, String, from: "containerIdentificationNumber")
      end
    end
  end
end
