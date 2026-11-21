# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The response schema for the `getFeatureSKU` operation.
      GetFeatureSKUResponse = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, GetFeatureSKUResult)
      end
    end
  end
end
