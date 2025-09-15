# frozen_string_literal: true

require "peddler/types/services_v1/appointment_time"
require "peddler/types/services_v1/technician"

module Peddler
  module Types
    module ServicesV1
      # Proof of Appointment (POA) details.
      Poa = Structure.new do
        # @return [AppointmentTime] The time of the appointment window.
        attribute(:appointment_time, AppointmentTime, from: "appointmentTime")

        # @return [Array<Technician>] A list of technicians.
        attribute(:technicians, [Technician])

        # @return [String] The identifier of the technician who uploaded the POA.
        attribute(:uploading_technician, String, from: "uploadingTechnician")

        # @return [String] The date and time when the POA was uploaded in ISO 8601 format.
        attribute(:upload_time, String, from: "uploadTime")

        # @return [String] The type of POA uploaded.
        attribute(:poa_type, String, from: "poaType")
      end
    end
  end
end
