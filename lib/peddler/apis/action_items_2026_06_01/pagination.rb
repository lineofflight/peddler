# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # Pagination details for list responses.
      Pagination = Structure.new do
        # @return [String] A token to retrieve the next page of results. Absent when there are no more results.
        attribute?(:next_token, String, from: "nextToken")

        # @return [String] A token to retrieve the previous page of results. Absent on the first page.
        attribute?(:previous_token, String, from: "previousToken")
      end
    end
  end
end
