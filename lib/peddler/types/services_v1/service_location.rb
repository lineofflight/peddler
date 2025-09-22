# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/address"

module Peddler
  module Types
    module ServicesV1
      # Information about the location of the service job.
      ServiceLocation = Structure.new do
        # @return [String] The location of the service job.
        attribute(:service_location_type, String, from: "serviceLocationType")

        # @return [Address] The shipping address for the service job.
        attribute(:address, Address)
      end
    end
  end
end
