# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/service_rate"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the getRates operation.
      GetRatesResult = Structure.new do
        # @return [Array<ServiceRate>]
        attribute(:service_rates, [ServiceRate], from: "serviceRates")
      end
    end
  end
end
