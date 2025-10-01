# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the getAdditionalInputs operation.
      GetAdditionalInputsResponse = Structure.new do
        # @return [Hash]
        attribute?(:payload, Hash)
      end
    end
  end
end
