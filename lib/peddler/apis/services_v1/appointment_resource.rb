# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # The resource that performs or performed appointment fulfillment.
      AppointmentResource = Structure.new do
        # @return [String] The resource identifier.
        attribute?(:resource_id, String, from: "resourceId")
      end
    end
  end
end
