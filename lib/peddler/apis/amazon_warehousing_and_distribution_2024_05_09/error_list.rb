# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # This exception is thrown when client inputs are invalid.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of errors describing the failures.
        attribute(:errors, [Error])
      end
    end
  end
end
