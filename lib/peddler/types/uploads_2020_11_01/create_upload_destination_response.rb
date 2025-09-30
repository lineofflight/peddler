# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/uploads_2020_11_01/upload_destination"
require "peddler/types/uploads_2020_11_01/error"

module Peddler
  module Types
    module Uploads20201101
      # The response schema for the createUploadDestination operation.
      CreateUploadDestinationResponse = Structure.new do
        # @return [UploadDestination]
        attribute?(:payload, UploadDestination)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
