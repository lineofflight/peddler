# frozen_string_literal: true

require "peddler/types/services_v1/job_listing"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `getServiceJobs` operation.
      GetServiceJobsResponse = Structure.new do
        # @return [JobListing] The payload for the `getServiceJobs` operation.
        attribute(:payload, JobListing)

        # @return [Array<Error>] An unexpected condition occurred during the `getServiceJobs` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
