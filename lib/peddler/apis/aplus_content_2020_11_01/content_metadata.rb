# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AplusContent20201101
      # The metadata of an A+ Content document.
      ContentMetadata = Structure.new do
        # @return [Array<ContentBadge>]
        attribute(:badge_set, Array, null: false, from: "badgeSet")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The A+ Content document name.
        attribute(:name, String, null: false)

        # @return [String]
        attribute(:status, String, null: false)

        # @return [Time] The approximate age of the A+ Content document and metadata.
        attribute(:update_time, Time, null: false, from: "updateTime")
      end
    end
  end
end
