# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The base response data for all A+ Content operations when a request is successful or partially successful.
      # Individual operations can extend this with additional data.
      AplusResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end
