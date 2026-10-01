# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # A list of support cases.
      ListCasesResult = Structure.new do
        # @return [Array<Case>] A paginated list of support cases.
        attribute(:cases, [Case], null: false)

        # @return [String] A token to retrieve the next page of results. The response includes `nextToken` when the
        #   number of results exceeds the specified `maxResults` value. To get the next page of results, call the
        #   operation with this token and include the same arguments as the call that produced the token. To get a
        #   complete list, call this operation until `nextToken` is null. Note that this operation can return empty
        #   pages.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
