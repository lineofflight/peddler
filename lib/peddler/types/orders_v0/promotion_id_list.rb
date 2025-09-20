# frozen_string_literal: true

module Peddler
  module Types
    module OrdersV0
      # A list of promotion identifiers provided by the seller when the promotions were created.
      class PromotionIdList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end
