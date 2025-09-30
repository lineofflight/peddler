# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricingV0
      # A list of product attributes if they are applicable to the product that is returned.
      class AttributeSetList < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
