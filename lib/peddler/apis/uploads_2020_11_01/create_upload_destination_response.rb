# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Uploads20201101
      # The response schema for the createUploadDestination operation.
      CreateUploadDestinationResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [UploadDestination]
        attribute?(:payload, UploadDestination)
      end
    end
  end
end
