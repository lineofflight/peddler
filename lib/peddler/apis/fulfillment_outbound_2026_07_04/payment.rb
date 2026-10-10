# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Payment details.
      Payment = Structure.new do
        # The payment identifier.
        attribute?(:payment_id, String, from: "paymentId")

        # The payment method.
        attribute?(:payment_method, String, from: "paymentMethod")

        # The time of the payment in ISO 8601 format.
        attribute?(:payment_time, Time, from: "paymentTime")
      end
    end
  end
end
