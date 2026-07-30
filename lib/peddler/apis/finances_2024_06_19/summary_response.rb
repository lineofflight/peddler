# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # The response to the `listSummary` operation.
      SummaryResponse = Structure.new do
        # @return [String] A token to retrieve the next page of results. If null, no more results are available.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<Summary>] A list of financial summaries.
        attribute?(:summaries, [Summary])
      end
    end
  end
end
