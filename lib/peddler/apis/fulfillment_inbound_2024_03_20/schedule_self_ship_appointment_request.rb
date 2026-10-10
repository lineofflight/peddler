# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `scheduleSelfShipAppointment` request.
      ScheduleSelfShipAppointmentRequest = Structure.new do
        attribute?(:reason_comment, String, from: "reasonComment")
      end
    end
  end
end
