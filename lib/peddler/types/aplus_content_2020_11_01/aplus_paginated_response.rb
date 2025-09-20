# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      # A token that you use to retrieve the next page of results. To get the next page of results, call the operation
      # with this token and include the same arguments as the call that produced the token. To get a complete list, call
      # this operation until `nextPageToken` is null. Note that this operation can return empty pages.
      AplusPaginatedResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:warnings, [Error])

        # @return [String]
        attribute(:next_page_token, String, from: "nextPageToken")
      end
    end
  end
end
