# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The response schema for the GetAccessPoints operation.
      GetAccessPointsResponse = Structure.new do
        attribute?(:payload, GetAccessPointsResult)
      end
    end
  end
end
