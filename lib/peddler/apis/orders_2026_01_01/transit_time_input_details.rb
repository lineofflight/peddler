# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Details about the carrier and shipping service used to calculate the transit time.
      TransitTimeInputDetails = Structure.new do
        # @return [String] The carrier name. For example, `Correios`.
        attribute?(:carrier, String)

        # @return [String] The shipping service. For example, `SEDEX`.
        attribute?(:shipping_service, String, from: "shippingService")
      end
    end
  end
end
