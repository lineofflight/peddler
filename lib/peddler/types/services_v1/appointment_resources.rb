# frozen_string_literal: true

require "peddler/types/services_v1/appointment_resource"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ServicesV1
      # List of resources that performs or performed job appointment fulfillment.
      class AppointmentResources < Array
        class << self
          def parse(array)
            new(array.map { |item| AppointmentResource.parse(item) })
          end
        end
      end
    end
  end
end
