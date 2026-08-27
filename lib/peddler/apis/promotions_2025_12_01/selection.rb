# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Defines which products qualify for a benefit, allowing either specific items to be selected by ASIN or the
      # entire catalog with optional exclusions.
      Selection = Structure.new do
        # @return [String] Selection type.
        attribute(:type, String, null: false)

        # @return [Integer] The revision identifier for the selection. Pass this value to the `getSelection` operation's
        #   `revisionId` query parameter to retrieve the correct version of the selection. A promotion may have multiple
        #   selection revisions when an update is in progress. **Note:** This field is absent when `type` is `CATALOG`.
        attribute?(:revision_id, Integer, from: "revisionId")

        # @return [SelectionDetails] Detailed selection information.
        attribute?(:selection_details, SelectionDetails, from: "selectionDetails")

        # @return [String] The unique identifier for this selection configuration. **Note:** This field is absent when
        #   `type` is `CATALOG`.
        attribute?(:selection_id, String, from: "selectionId")
      end
    end
  end
end
