# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list that contains product variation information, if applicable.
      class RelationshipList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
