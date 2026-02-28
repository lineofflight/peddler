# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Request schema for the `assignAppointmentResources` operation.
      AssignAppointmentResourcesRequest = Structure.new do
        # @return [Array<AppointmentResource>] List of resource objects to be assigned.
        attribute(:resources, [AppointmentResource], null: false)
      end
    end
  end
end
