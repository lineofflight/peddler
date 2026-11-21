# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `generateDeliveryWindowOptions` response.
      GenerateDeliveryWindowOptionsResponse = Structure.new do
        # UUID for the given operation.
        attribute(:operation_id, String, null: false, from: "operationId")
      end
    end
  end
end
