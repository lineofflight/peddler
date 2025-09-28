# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # Specify the type of attributes to be added on a label.
      class RequestAttributes < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
