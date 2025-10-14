# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Total invoice defects count due to missing invoice and late invoice.
      InvoiceDefect = Structure.new do
        # @return [Integer] Invoice defects count.
        attribute(:count, Integer)

        # @return [String]
        attribute(:status, String)
      end
    end
  end
end
