# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Finances20240601
      # The list of payment method types that are present.
      class PaymentMethodTypeList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
