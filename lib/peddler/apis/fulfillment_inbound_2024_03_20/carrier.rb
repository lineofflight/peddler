# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The carrier for the inbound shipment.
      Carrier = Structure.new do
        # The carrier code. For example, USPS or DHLEX.
        attribute?(:alpha_code, String, from: "alphaCode")

        # The name of the carrier.
        attribute?(:name, String)
      end
    end
  end
end
