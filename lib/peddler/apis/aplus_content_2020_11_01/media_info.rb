# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The core media entity attributes without associations.
      MediaInfo = Structure.new do
        # The unique identifier for the media asset.
        attribute(:media_id, String, null: false, from: "mediaId")

        # The type of media asset. Known values: `VIDEO`, `IMAGE`.
        attribute(:media_type, String, null: false, from: "mediaType")

        # The composite status of the media asset. Multiple statuses can apply simultaneously to represent both the
        # workflow stage and the responsible actor. Known values: `PENDING_PROCESSING`, `PENDING_REVIEW`,
        # `UNABLE_TO_PROCESS`, `NOT_APPROVED`, `AVAILABLE`, `PENDING_AMAZON`, `PENDING_SELLING_PARTNER`.
        attribute(:status, Array, null: false)

        # The title for the media asset. For videos, this is the original filename. For images, this is the
        # user-provided title or filename.
        attribute(:title, String, null: false)

        # Accessibility descriptions for the media asset. Present for video assets only. Shared across all pairings.
        attribute?(:descriptions, [Description])

        # Issues associated with the media asset.
        attribute?(:issues, [Issue])

        # The CDN URL for downloading or viewing the media asset. The URL is provisioned at upload time and available in
        # all statuses. The media is non-permanent; you should re-retrieve using `getMedia` rather than caching
        # indefinitely.
        attribute?(:media_url, String, from: "mediaUrl")
      end
    end
  end
end
