# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `scheduleSelfShipAppointment` response.
      ScheduleSelfShipAppointmentResponse = Structure.new do
        # @return [SelfShipAppointmentDetails]
        attribute(:self_ship_appointment_details, SelfShipAppointmentDetails, from: "selfShipAppointmentDetails")
      end
    end
  end
end
