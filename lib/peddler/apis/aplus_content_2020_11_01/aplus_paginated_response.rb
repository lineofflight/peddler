# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The base response data for paginated A+ Content operations. Individual operations may extend this with
      # additional data. If `nextPageToken` is not returned, there are no more pages to return.
      AplusPaginatedResponse = Structure.new do
        # @return [String]
        attribute?(:next_page_token, String, from: "nextPageToken")

        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end
