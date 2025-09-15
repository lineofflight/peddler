# frozen_string_literal: true

require "peddler/types/services_v1/appointment_resource"

module Peddler
  module Types
    module ServicesV1
      # Request schema for the `assignAppointmentResources` operation.
      AssignAppointmentResourcesRequest = Structure.new do
        # @return [Array<AppointmentResource>] List of resource objects to be assigned.
        attribute(:resources, [AppointmentResource])
      end
    end
  end
end
