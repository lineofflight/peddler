# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Feeds20210630
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] An error response returned when the request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
