# frozen_string_literal: true

require "peddler/types/finances_v0/promotion"

module Peddler
  module Types
    module FinancesV0
      # A list of promotions.
      class PromotionList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Promotion.parse(item) })
          end
        end
      end
    end
  end
end
