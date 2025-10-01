# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Uploads20201101
      # Information about an upload destination.
      UploadDestination = Structure.new do
        # @return [Hash] The headers to include in the upload request.
        attribute?(:headers, Hash)

        # @return [String] The unique identifier for the upload destination.
        attribute?(:upload_destination_id, String, from: "uploadDestinationId")

        # @return [String] The URL for the upload destination.
        attribute?(:url, String)
      end
    end
  end
end
