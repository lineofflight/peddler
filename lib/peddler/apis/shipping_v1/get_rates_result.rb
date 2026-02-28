# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the getRates operation.
      GetRatesResult = Structure.new do
        # @return [Array<ServiceRate>]
        attribute(:service_rates, [ServiceRate], null: false, from: "serviceRates")
      end
    end
  end
end
