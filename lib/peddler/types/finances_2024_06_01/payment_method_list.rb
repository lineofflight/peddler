# frozen_string_literal: true

require "peddler/types/finances_2024_06_01/payment_method_details"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Finances20240601
      # The list of payment methods with payment method details.
      class PaymentMethodList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| PaymentMethodDetails.parse(item) }) : new
          end
        end
      end
    end
  end
end
