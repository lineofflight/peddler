# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The request body for creating a media asset. Uses the unified media shape as a subset, omitting system-derived
      # fields.
      CreateMediaRequest = Structure.new do
        # @return [String] The type of media asset to create.
        attribute(:media_type, String, null: false, from: "mediaType")

        # @return [Array<Description>] Accessibility descriptions for video assets. Required when `mediaType` is
        #   `VIDEO`. At least one entry required.
        attribute?(:descriptions, [Description])

        # @return [String] An existing media asset identifier for reuse. Mutually exclusive with `uploadDestinationId`.
        attribute?(:media_id, String, from: "mediaId")

        # @return [Array<RelatedMediaInput>] Related media to associate during creation. Required when `mediaType` is
        #   `VIDEO` (at least one `VIDEO_PAIRING` entry with an image must be provided). Ignored when `mediaType` is
        #   `IMAGE`.
        attribute?(:related_media, [RelatedMediaInput], from: "relatedMedia")

        # @return [String] An optional title for the media asset. For standalone images, defaults to filename if not
        #   provided. Not applicable for videos (video title is derived from the filename).
        attribute?(:title, String)

        # @return [String] The S3 upload destination identifier from the `createUploadDestination` operation. Mutually
        #   exclusive with `mediaId`.
        attribute?(:upload_destination_id, String, from: "uploadDestinationId")
      end
    end
  end
end
