# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/service_job"

module Peddler
  module Types
    module ServicesV1
      # The payload for the `getServiceJobs` operation.
      JobListing = Structure.new do
        # @return [Integer] Total result size of the query result.
        attribute?(:total_result_size, Integer, from: "totalResultSize")

        # @return [String] A generated string used to pass information to your next request. If `nextPageToken` is
        # returned, pass the value of `nextPageToken` to the `pageToken` to get next results.
        attribute?(:next_page_token, String, from: "nextPageToken")

        # @return [String] A generated string used to pass information to your next request. If `previousPageToken` is
        # returned, pass the value of `previousPageToken` to the `pageToken` to get previous page results.
        attribute?(:previous_page_token, String, from: "previousPageToken")

        # @return [Array<ServiceJob>] List of job details for the given input.
        attribute?(:jobs, [ServiceJob])
      end
    end
  end
end
