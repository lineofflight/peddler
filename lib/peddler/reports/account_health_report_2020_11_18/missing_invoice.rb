# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Total missing invoice count in the time window.
      MissingInvoice = Structure.new do
        # @return [Integer] Missing invoice defects count.
        attribute(:count, Integer)

        # @return [String]
        attribute(:status, String)
      end
    end
  end
end
