# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Payment information for the order. Currently only available in India.
      PaymentInformation = Structure.new do
        # @return [Array<Payment>] A list of payments associated with the order.
        attribute?(:payments, [Payment])
      end
    end
  end
end
