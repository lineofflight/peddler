# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Total late invoice count in the time window.
      LateInvoice = Structure.new do
        # Late invoice defects count.
        attribute(:count, Integer, null: false)

        attribute(:status, String, null: false)
      end
    end
  end
end
