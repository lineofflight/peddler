# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV1
      # The payload schema for the getRates operation.
      GetRatesRequest = Structure.new do
        attribute(:container_specifications, [ContainerSpecification], null: false, from: "containerSpecifications")

        # Known values: `Amazon Shipping Ground`, `Amazon Shipping Standard`, `Amazon Shipping Premium`.
        attribute(:service_types, Array, null: false, from: "serviceTypes")

        attribute(:ship_from, Address, null: false, from: "shipFrom")

        attribute(:ship_to, Address, null: false, from: "shipTo")

        # The start date and time. This defaults to the current date and time.
        attribute?(:ship_date, Time, from: "shipDate")
      end
    end
  end
end
