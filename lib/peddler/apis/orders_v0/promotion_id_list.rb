# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class OrdersV0
      # A list of promotion identifiers provided by the seller when the promotions were created.
      class PromotionIdList < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
