# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/container_specification"
require "peddler/types/shipping_v1/address"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the getRates operation.
      GetRatesRequest = Structure.new do
        # @return [Array<ContainerSpecification>]
        attribute(:container_specifications, [ContainerSpecification], from: "containerSpecifications")

        # @return [Array<ServiceType>]
        attribute(:service_types, Array, from: "serviceTypes")

        # @return [Address]
        attribute(:ship_from, Address, from: "shipFrom")

        # @return [Address]
        attribute(:ship_to, Address, from: "shipTo")

        # @return [String] The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, String, from: "shipDate")
      end
    end
  end
end
