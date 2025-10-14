# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # The response schema for the `getServiceJobByServiceJobId` operation.
      GetServiceJobByServiceJobIdResponse = Structure.new do
        # @return [Array<Error>] An unexpected condition occurred during the `getServiceJobByServiceJobId` operation.
        attribute?(:errors, [Error])

        # @return [ServiceJob] The payload for the `getServiceJobByServiceJobId` operation.
        attribute?(:payload, ServiceJob)
      end
    end
  end
end
