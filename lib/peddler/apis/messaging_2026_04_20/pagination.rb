# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Messaging20260420
      # Contains a token for retrieving the next page of results. Only present when additional pages are available.
      Pagination = Structure.new do
        # A token to fetch the next page of results. Absent when no further pages exist.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
