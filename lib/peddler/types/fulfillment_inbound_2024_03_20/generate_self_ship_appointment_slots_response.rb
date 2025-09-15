# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `generateSelfShipAppointmentSlots` response.
      GenerateSelfShipAppointmentSlotsResponse = Structure.new do
        # @return [String] UUID for the given operation.
        attribute(:operation_id, String, from: "operationId")
      end
    end
  end
end
