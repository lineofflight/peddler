# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Response schema for the `getServiceJobs` operation.
      GetServiceJobsResponse = Structure.new do
        # An unexpected condition occurred during the `getServiceJobs` operation.
        attribute?(:errors, [Error])

        # The payload for the `getServiceJobs` operation.
        attribute?(:payload, JobListing)
      end
    end
  end
end
