# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The response for the `getMedia` operation. Returns the full unified Media shape.
      GetMediaResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end
