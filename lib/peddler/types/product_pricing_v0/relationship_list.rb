# frozen_string_literal: true

module Peddler
  module Types
    module ProductPricingV0
      # A list that contains product variation information, if applicable.
      class RelationshipList < Array
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
