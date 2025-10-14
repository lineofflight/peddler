# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # The response schema for the CreateInventoryItem operation.
      CreateInventoryItemResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the CreateInventoryItem operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
