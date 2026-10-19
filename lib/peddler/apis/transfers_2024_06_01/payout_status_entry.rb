# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Transfers20240601
      # A record of a payout's status at a specific point in time.
      PayoutStatusEntry = Structure.new do
        # The date when this status was last updated.
        attribute(:last_updated_date, String, null: false, from: "lastUpdatedDate")

        # The payout status when this entry was recorded. Known values: `STARTED`, `IN_TRANSIT`, `PAID`, `FAILED`,
        # `CANCELLED`, `NO_PAYOUT`.
        attribute(:status, String, null: false)

        # The reason the payout failed.
        attribute?(:failure_reason, String, from: "failureReason")
      end
    end
  end
end
