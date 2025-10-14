# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Service Selection Criteria.
      ServiceSelection = Structure.new do
        # @return [Array<String>]
        attribute(:service_id, [String], from: "serviceId")
      end
    end
  end
end
