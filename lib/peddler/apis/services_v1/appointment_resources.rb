# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ServicesV1
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
