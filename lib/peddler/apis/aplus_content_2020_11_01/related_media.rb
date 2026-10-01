# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A relationship between media assets, representing a pairing with its own title, status, and lifecycle.
      RelatedMedia = Structure.new do
        # @return [String] The type of relationship.
        attribute(:association_type, String, null: false, from: "associationType")

        # @return [MediaInfo] The associated media asset, without nested associations.
        attribute(:media, MediaInfo, null: false)

        # @return [Array<MediaStatus>] The composite status of this pairing. Multiple statuses can apply simultaneously
        #   to represent both the workflow stage and the responsible actor.
        attribute(:status, Array, null: false)

        # @return [String] The title for this pairing. For `VIDEO_PAIRING`, this is the user-provided pairing title.
        #   Minimum three words; must not be all capital letters.
        attribute(:title, String, null: false)

        # @return [Array<Issue>] Issues associated with this pairing.
        attribute?(:issues, [Issue])
      end
    end
  end
end
