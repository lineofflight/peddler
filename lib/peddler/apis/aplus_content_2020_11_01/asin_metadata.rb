# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The A+ Content ASIN with additional metadata for content management. If you don't include the `includedDataSet`
      # parameter in a call to the `listContentDocumentAsinRelations` operation, the related ASINs are returned without
      # metadata.
      ASINMetadata = Structure.new do
        attribute(:asin, String, null: false)

        # Known values: `BRAND_NOT_ELIGIBLE`, `CATALOG_NOT_FOUND`, `CONTENT_NOT_PUBLISHED`, `CONTENT_PUBLISHED`.
        attribute?(:badge_set, Array, from: "badgeSet")

        attribute?(:content_reference_key_set, Array, from: "contentReferenceKeySet")

        # The default image for the ASIN in the Amazon catalog.
        attribute?(:image_url, String, from: "imageUrl")

        attribute?(:parent, String)

        # The title for the ASIN in the Amazon catalog.
        attribute?(:title, String)
      end
    end
  end
end
