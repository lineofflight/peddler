# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      # The error response that is returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of error responses that are returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
