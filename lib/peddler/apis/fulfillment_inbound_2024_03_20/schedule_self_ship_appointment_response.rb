# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `scheduleSelfShipAppointment` response.
      ScheduleSelfShipAppointmentResponse = Structure.new do
        attribute(:self_ship_appointment_details, SelfShipAppointmentDetails, null: false, from: "selfShipAppointmentDetails")
      end
    end
  end
end
