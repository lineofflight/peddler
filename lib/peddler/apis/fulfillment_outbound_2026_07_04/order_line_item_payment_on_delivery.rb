# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Payment on delivery settings. Currently only available in India.
      OrderLineItemPaymentOnDelivery = Structure.new do
        # @return [Money]
        attribute?(:per_unit_service_price, Money, from: "perUnitServicePrice")
      end
    end
  end
end
