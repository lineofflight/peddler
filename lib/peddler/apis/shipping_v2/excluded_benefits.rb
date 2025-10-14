# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of excluded benefit. Refer to the ExcludeBenefit object for further documentation
      class ExcludedBenefits < Array
        class << self
          def parse(array)
            new(array.map { |item| ExcludedBenefit.parse(item) })
          end
        end
      end
    end
  end
end
