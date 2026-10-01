# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The request body for updating media metadata. Exactly one of title or descriptions must be provided.
      UpdateMediaRequest = Structure.new do
        # @return [Array<Description>] Updated accessibility descriptions. Upserts provided locale entries; omitted
        #   locales are preserved. Only valid when `mediaId` refers to a video and `associatedMediaId` is not provided.
        attribute?(:descriptions, [Description])

        # @return [String] The updated title. When `associatedMediaId` query parameter is provided, updates the pairing
        #   title (minimum 3 words). When absent and `mediaId` is an image, updates the image title.
        attribute?(:title, String)
      end
    end
  end
end
