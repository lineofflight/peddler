# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # The HTTP status associated with the response for an individual request within a batch.
      HttpStatusLine = Structure.new do
        # @return [String] The HTTP response reason phrase.
        attribute?(:reason_phrase, String, from: "reasonPhrase")

        # @return [Integer] The HTTP response status code.
        attribute?(:status_code, Integer, from: "statusCode")
      end
    end
  end
end
