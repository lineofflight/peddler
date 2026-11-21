# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Replenishment20221107
      # The discount funding on the offer.
      DiscountFunding = Structure.new do
        # Filters the results to only include offers with the percentage specified.
        attribute?(:percentage, [Float])
      end
    end
  end
end
