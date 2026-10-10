# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The breakdown of eligibility inventory by feature.
      GetFeatureInventoryResponse = Structure.new do
        # One or more unexpected errors occurred during the getFeatureInventory operation.
        attribute?(:errors, [Error])

        attribute?(:payload, GetFeatureInventoryResult)
      end
    end
  end
end
