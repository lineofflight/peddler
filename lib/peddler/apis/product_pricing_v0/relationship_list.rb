# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricingV0
      # A list that contains product variation information, if applicable.
      class RelationshipList < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
