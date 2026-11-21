# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # The root schema comprises the entire JSON document.
      Report = Structure.new do
        # Seller's corresponding account status for each requested marketplace.
        attribute(:account_statuses, Array, null: false, from: "accountStatuses")

        # Seller's performance metrics for requeted marketpalces.
        attribute(:performance_metrics, Array, null: false, from: "performanceMetrics")
      end
    end
  end
end
