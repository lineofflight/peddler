# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Execution errors associated with the outbound order. This field will be populated if the order failed
      # validation.
      OutboundExecutionError = Structure.new do
        # Failure code details for the error.
        attribute(:failure_code, String, null: false, from: "failureCode")

        # Failure reasons for the error.
        attribute(:failure_reasons, [String], null: false, from: "failureReasons")

        # MSKU associated with the error.
        attribute?(:sku, String)
      end
    end
  end
end
