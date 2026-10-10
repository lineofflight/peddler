# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Input for referencing a media asset during creation. Exactly one of `uploadDestinationId` or `mediaId` must be
      # provided.
      MediaInput = Structure.new do
        # The type of media asset.
        attribute(:media_type, String, null: false, from: "mediaType")

        # An existing media asset identifier for reuse in a new association. Mutually exclusive with
        # `uploadDestinationId`.
        attribute?(:media_id, String, from: "mediaId")

        # An optional title for the media asset. Defaults to the filename if not provided.
        attribute?(:title, String)

        # The S3 upload destination identifier from the `createUploadDestination` operation, for a newly uploaded asset.
        # Mutually exclusive with `mediaId`.
        attribute?(:upload_destination_id, String, from: "uploadDestinationId")
      end
    end
  end
end
