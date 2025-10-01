# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `assignAppointmentResources` operation.
      AssignAppointmentResourcesResponse = Structure.new do
        # @return [Array<Error>] Errors occurred during during the `assignAppointmentResources` operation.
        attribute?(:errors, [Error])

        # @return [Hash] The payload for the `assignAppointmentResource` operation.
        attribute?(:payload, Hash)
      end
    end
  end
end
