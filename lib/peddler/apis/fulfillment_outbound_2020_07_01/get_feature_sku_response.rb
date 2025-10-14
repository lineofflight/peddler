# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The response schema for the `getFeatureSKU` operation.
      GetFeatureSKUResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetFeatureSKUResult]
        attribute?(:payload, GetFeatureSKUResult)
      end
    end
  end
end
