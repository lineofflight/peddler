# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Input for creating a media association.
      RelatedMediaInput = Structure.new do
        # The type of relationship to create. Known values: `VIDEO_PAIRING`.
        attribute(:association_type, String, null: false, from: "associationType")

        # The media asset to associate.
        attribute(:media, MediaInput, null: false)

        # The title for this pairing. Minimum three words for `VIDEO_PAIRING`; must not be all capital letters.
        attribute(:title, String, null: false)
      end
    end
  end
end
