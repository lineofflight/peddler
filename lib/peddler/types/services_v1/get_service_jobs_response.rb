# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/job_listing"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `getServiceJobs` operation.
      GetServiceJobsResponse = Structure.new do
        # @return [Array<Error>] An unexpected condition occurred during the `getServiceJobs` operation.
        attribute?(:errors, [Error])

        # @return [JobListing] The payload for the `getServiceJobs` operation.
        attribute?(:payload, JobListing)
      end
    end
  end
end
