# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's MFN/AFN order defect rate within a given reporting date range for 1 requested marketplace.
      OrderDefectRate = Structure.new do
        # @return [:self]
        attribute(:afn, :self, null: false)

        # @return [:self]
        attribute(:mfn, :self, null: false)
      end
    end
  end
end
