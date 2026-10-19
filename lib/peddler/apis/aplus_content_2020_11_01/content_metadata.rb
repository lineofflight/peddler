# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module AplusContent20201101
      # The metadata of an A+ Content document.
      ContentMetadata = Structure.new do
        # Known values: `BULK`, `GENERATED`, `LAUNCHPAD`, `PREMIUM`, `STANDARD`.
        attribute(:badge_set, Array, null: false, from: "badgeSet")

        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The A+ Content document name.
        attribute(:name, String, null: false)

        # Known values: `APPROVED`, `DRAFT`, `REJECTED`, `SUBMITTED`.
        attribute(:status, String, null: false)

        # The approximate age of the A+ Content document and metadata.
        attribute(:update_time, Time, null: false, from: "updateTime")
      end
    end
  end
end
