# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentLocation20260730
      # The response object for creating a sandbox location.
      CreateSandboxLocationResponse = Structure.new do
        # @return [LocationIdMap]
        attribute?(:location_ids, LocationIdMap, from: "locationIds")
      end
    end
  end
end
