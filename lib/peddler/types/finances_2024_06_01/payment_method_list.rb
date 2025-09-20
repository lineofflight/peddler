# frozen_string_literal: true

require "peddler/types/finances_2024_06_01/payment_method_details"

module Peddler
  module Types
    module Finances20240601
      # The list of payment methods with payment method details.
      class PaymentMethodList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PaymentMethodDetails.parse(item) })
          end
        end
      end
    end
  end
end
