# frozen_string_literal: true

require "peddler/types/services_v1/appointment_resource"

module Peddler
  module Types
    module ServicesV1
      # List of resources that performs or performed job appointment fulfillment.
      class AppointmentResources < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AppointmentResource.parse(item) })
          end
        end
      end
    end
  end
end
