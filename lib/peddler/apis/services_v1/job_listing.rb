# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # The payload for the `getServiceJobs` operation.
      JobListing = Structure.new do
        # @return [Array<ServiceJob>] List of job details for the given input.
        attribute?(:jobs, [ServiceJob])

        # @return [String] A generated string used to pass information to your next request. If `nextPageToken` is
        #   returned, pass the value of `nextPageToken` to the `pageToken` to get next results.
        attribute?(:next_page_token, String, from: "nextPageToken")

        # @return [String] A generated string used to pass information to your next request. If `previousPageToken` is
        #   returned, pass the value of `previousPageToken` to the `pageToken` to get previous page results.
        attribute?(:previous_page_token, String, from: "previousPageToken")

        # @return [Integer] Total result size of the query result.
        attribute?(:total_result_size, Integer, from: "totalResultSize")
      end
    end
  end
end
