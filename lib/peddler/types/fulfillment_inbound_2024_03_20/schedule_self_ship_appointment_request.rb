# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `scheduleSelfShipAppointment` request.
      ScheduleSelfShipAppointmentRequest = Structure.new do
        # @return [String]
        attribute(:reason_comment, String, from: "reasonComment")
      end
    end
  end
end
