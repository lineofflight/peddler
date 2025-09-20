# frozen_string_literal: true

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The list of payment method details.
      class PaymentMethodDetailItemList < Array
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
