# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The list of payment method details.
      class PaymentMethodDetailItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
