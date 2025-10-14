# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content ASIN with additional metadata for content management. If you don't include the `includedDataSet`
      # parameter in a call to the `listContentDocumentAsinRelations` operation, the related ASINs are returned without
      # metadata.
      ASINMetadata = Structure.new do
        # @return [String]
        attribute(:asin, String)

        # @return [Array<AsinBadge>]
        attribute?(:badge_set, Array, from: "badgeSet")

        # @return [Array<ContentReferenceKey>]
        attribute?(:content_reference_key_set, Array, from: "contentReferenceKeySet")

        # @return [String] The default image for the ASIN in the Amazon catalog.
        attribute?(:image_url, String, from: "imageUrl")

        # @return [String]
        attribute?(:parent, String)

        # @return [String] The title for the ASIN in the Amazon catalog.
        attribute?(:title, String)
      end
    end
  end
end
