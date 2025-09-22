# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      ValidateContentDocumentAsinRelationsResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:warnings, [Error])

        # @return [Array<Error>] A list of error responses that are returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
