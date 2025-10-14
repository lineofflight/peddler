# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Transfers20240601
      # The list of payment methods with payment method details.
      class PaymentMethodList < Array
        class << self
          def parse(array)
            new(array.map { |item| PaymentMethodDetails.parse(item) })
          end
        end
      end
    end
  end
end
