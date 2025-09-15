# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `cancelSelfShipAppointment` request.
      CancelSelfShipAppointmentRequest = Structure.new do
        # @return [String]
        attribute(:reason_comment, String, from: "reasonComment")
      end
    end
  end
end
