# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A relationship between media assets, representing a pairing with its own title, status, and lifecycle.
      RelatedMedia = Structure.new do
        # The type of relationship. Known values: `VIDEO_PAIRING`.
        attribute(:association_type, String, null: false, from: "associationType")

        # The associated media asset, without nested associations.
        attribute(:media, MediaInfo, null: false)

        # The composite status of this pairing. Multiple statuses can apply simultaneously to represent both the
        # workflow stage and the responsible actor. Known values: `PENDING_PROCESSING`, `PENDING_REVIEW`,
        # `UNABLE_TO_PROCESS`, `NOT_APPROVED`, `AVAILABLE`, `PENDING_AMAZON`, `PENDING_SELLING_PARTNER`.
        attribute(:status, Array, null: false)

        # The title for this pairing. For `VIDEO_PAIRING`, this is the user-provided pairing title. Minimum three words;
        # must not be all capital letters.
        attribute(:title, String, null: false)

        # Issues associated with this pairing.
        attribute?(:issues, [Issue])
      end
    end
  end
end
