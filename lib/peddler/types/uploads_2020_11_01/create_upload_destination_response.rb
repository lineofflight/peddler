# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/uploads_2020_11_01/error"
require "peddler/types/uploads_2020_11_01/upload_destination"

module Peddler
  module Types
    module Uploads20201101
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
