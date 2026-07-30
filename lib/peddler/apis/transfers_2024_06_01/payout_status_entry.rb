# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # A record of a payout's status at a specific point in time.
      PayoutStatusEntry = Structure.new do
        # @return [String] The date when this status was last updated.
        attribute(:last_updated_date, String, null: false, from: "lastUpdatedDate")

        # @return [String] The payout status when this entry was recorded.
        attribute(:status, String, null: false)

        # @return [String] The reason the payout failed.
        attribute?(:failure_reason, String, from: "failureReason")
      end
    end
  end
end
