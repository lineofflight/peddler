# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Input for creating a media association.
      RelatedMediaInput = Structure.new do
        # @return [String] The type of relationship to create.
        attribute(:association_type, String, null: false, from: "associationType")

        # @return [MediaInput] The media asset to associate.
        attribute(:media, MediaInput, null: false)

        # @return [String] The title for this pairing. Minimum three words for `VIDEO_PAIRING`; must not be all capital
        #   letters.
        attribute(:title, String, null: false)
      end
    end
  end
end
