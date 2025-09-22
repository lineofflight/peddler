# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/address"
require "peddler/types/shipping_v1/container_specification"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the getRates operation.
      GetRatesRequest = Structure.new do
        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Array<ServiceType>]
        attribute(:service_types, Array, from: "serviceTypes")

        # @return [String] The start date and time. This defaults to the current date and time.
        attribute(:ship_date, String, from: "shipDate")

        # @return [Array<ContainerSpecification>]
        attribute(:container_specifications, [ContainerSpecification], from: "containerSpecifications")
      end
    end
  end
end
