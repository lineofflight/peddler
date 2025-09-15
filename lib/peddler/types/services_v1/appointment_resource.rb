# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ServicesV1
      # The resource that performs or performed appointment fulfillment.
      AppointmentResource = Structure.new do
        # @return [String] The resource identifier.
        attribute(:resource_id, String, from: "resourceId")
      end
    end
  end
end
