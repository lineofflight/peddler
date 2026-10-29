# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Cursor-based pagination metadata.
      Pagination = Structure.new do
        # @return [String] Token to retrieve the next page. Absent when no more results.
        attribute?(:next_token, String, from: "nextToken")

        # @return [String] A token to retrieve the previous page of results. This value is not yet supported.
        attribute?(:previous_token, String, from: "previousToken")
      end
    end
  end
end
