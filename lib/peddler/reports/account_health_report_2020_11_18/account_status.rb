# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's corresponding account status for 1 requested marketplace.
      AccountStatus = Structure.new do
        # @return [String] A requested marketplace ID.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] Seller's account status for a requested marketplace.
        attribute(:status, String)
      end
    end
  end
end
