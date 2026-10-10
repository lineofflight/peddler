# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # The resource that performs or performed appointment fulfillment.
      AppointmentResource = Structure.new do
        # The resource identifier.
        attribute?(:resource_id, String, from: "resourceId")
      end
    end
  end
end
