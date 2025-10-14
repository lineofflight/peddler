# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV1
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

        # @return [Time] The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")
      end
    end
  end
end
