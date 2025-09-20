# frozen_string_literal: true

module Peddler
  module Types
    module ShippingV2
      # Specify the type of attributes to be added on a label.
      class RequestAttributes < Array
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
