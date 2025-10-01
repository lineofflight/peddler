# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The carrier for the inbound shipment.
      Carrier = Structure.new do
        # @return [String] The carrier code. For example, USPS or DHLEX.
        attribute?(:alpha_code, String, from: "alphaCode")

        # @return [String] The name of the carrier.
        attribute?(:name, String)
      end
    end
  end
end
