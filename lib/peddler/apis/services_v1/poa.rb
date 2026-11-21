# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ServicesV1
      # Proof of Appointment (POA) details.
      Poa = Structure.new do
        # The time of the appointment window.
        attribute?(:appointment_time, AppointmentTime, from: "appointmentTime")

        # The type of POA uploaded. Known values: `NO_SIGNATURE_DUMMY_POS`, `CUSTOMER_SIGNATURE`, `DUMMY_RECEIPT`,
        # `POA_RECEIPT`.
        attribute?(:poa_type, String, from: "poaType")

        # A list of technicians.
        attribute?(:technicians, [Technician])

        # The date and time when the POA was uploaded in ISO 8601 format.
        attribute?(:upload_time, Time, from: "uploadTime")

        # The identifier of the technician who uploaded the POA.
        attribute?(:uploading_technician, String, from: "uploadingTechnician")
      end
    end
  end
end
