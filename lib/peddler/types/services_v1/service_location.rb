# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/address"

module Peddler
  module Types
    module ServicesV1
      # Information about the location of the service job.
      ServiceLocation = Structure.new do
        # @return [Address] The shipping address for the service job.
        attribute?(:address, Address)

        # @return [String] The location of the service job.
        attribute?(:service_location_type, String, from: "serviceLocationType")
      end
    end
  end
end
