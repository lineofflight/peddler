# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller account warning state for 1 requested marketplace.
      WarningState = Structure.new do
        # @return [String] Seller account warning state status for 1 requested marketplace. It could be GOOD or BAD or
        #   NONE.
        attribute(:status, String)

        # @return [String] Seller account warning type for 1 requested marketplace.
        attribute(:warning_type, String, from: "warningType")
      end
    end
  end
end
