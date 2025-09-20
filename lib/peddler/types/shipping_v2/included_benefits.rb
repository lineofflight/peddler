# frozen_string_literal: true

module Peddler
  module Types
    module ShippingV2
      # A list of included benefits.
      class IncludedBenefits < Array
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
