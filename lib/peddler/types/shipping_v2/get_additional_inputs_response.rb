# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/get_additional_inputs_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the getAdditionalInputs operation.
      GetAdditionalInputsResponse = Structure.new do
        # @return [GetAdditionalInputsResult]
        attribute?(:payload, GetAdditionalInputsResult)
      end
    end
  end
end
