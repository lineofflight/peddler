# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Payment details.
      Payment = Structure.new do
        # @return [String] The payment identifier.
        attribute?(:payment_id, String, from: "paymentId")

        # @return [String] The payment method.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [Time] The time of the payment in ISO 8601 format.
        attribute?(:payment_time, Time, from: "paymentTime")
      end
    end
  end
end
