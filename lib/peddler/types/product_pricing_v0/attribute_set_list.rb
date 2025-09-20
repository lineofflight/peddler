# frozen_string_literal: true

module Peddler
  module Types
    module ProductPricingV0
      # A list of product attributes if they are applicable to the product that is returned.
      class AttributeSetList < Array
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
