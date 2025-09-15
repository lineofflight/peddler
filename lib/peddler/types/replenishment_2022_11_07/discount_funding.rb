# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # The discount funding on the offer.
      DiscountFunding = Structure.new do
        # @return [Array<Number>] Filters the results to only include offers with the percentage specified.
        attribute(:percentage, [Float])
      end
    end
  end
end
