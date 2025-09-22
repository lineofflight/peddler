# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/service_job"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # The response schema for the `getServiceJobByServiceJobId` operation.
      GetServiceJobByServiceJobIdResponse = Structure.new do
        # @return [ServiceJob] The payload for the `getServiceJobByServiceJobId` operation.
        attribute(:payload, ServiceJob)

        # @return [Array<Error>] An unexpected condition occurred during the `getServiceJobByServiceJobId` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
