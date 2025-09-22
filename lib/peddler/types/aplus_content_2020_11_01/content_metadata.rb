# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content document's metadata.
      ContentMetadata = Structure.new do
        # @return [String] The A+ Content document's name.
        attribute(:name, String)

        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:status, String)

        # @return [Array<ContentBadge>]
        attribute(:badge_set, Array, from: "badgeSet")

        # @return [String] The approximate age of the A+ Content document and metadata.
        attribute(:update_time, String, from: "updateTime")
      end
    end
  end
end
