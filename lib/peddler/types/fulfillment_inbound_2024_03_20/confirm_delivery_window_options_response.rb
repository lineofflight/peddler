# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `confirmDeliveryWindowOptions` response.
      ConfirmDeliveryWindowOptionsResponse = Structure.new do
        # @return [String] UUID for the given operation.
        attribute(:operation_id, String, from: "operationId")
      end
    end
  end
end
