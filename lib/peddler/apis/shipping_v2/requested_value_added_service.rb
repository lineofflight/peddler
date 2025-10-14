# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A value-added service to be applied to a shipping service purchase.
      RequestedValueAddedService = Structure.new do
        # @return [String] The identifier of the selected value-added service. Must be among those returned in the
        # response to the getRates operation.
        attribute(:id, String)
      end
    end
  end
end
