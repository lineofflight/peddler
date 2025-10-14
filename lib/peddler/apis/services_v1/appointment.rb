# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # The details of an appointment.
      Appointment = Structure.new do
        # @return [String] The appointment identifier.
        attribute?(:appointment_id, String, from: "appointmentId")

        # @return [String] The status of the appointment.
        attribute?(:appointment_status, String, from: "appointmentStatus")

        # @return [AppointmentTime] The time of the appointment window.
        attribute?(:appointment_time, AppointmentTime, from: "appointmentTime")

        # @return [Array<Technician>] A list of technicians assigned to the service job.
        attribute?(:assigned_technicians, [Technician], from: "assignedTechnicians")

        # @return [Poa] Proof of Appointment (POA) details.
        attribute?(:poa, Poa)

        # @return [String] The identifier of a rescheduled appointment.
        attribute?(:rescheduled_appointment_id, String, from: "rescheduledAppointmentId")
      end
    end
  end
end
