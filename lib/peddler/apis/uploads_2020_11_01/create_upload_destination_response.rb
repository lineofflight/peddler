# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Uploads20201101
      # The response schema for the createUploadDestination operation.
      CreateUploadDestinationResponse = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, UploadDestination)
      end
    end
  end
end
