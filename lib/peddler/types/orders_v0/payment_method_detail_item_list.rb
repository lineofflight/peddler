# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module OrdersV0
      # A list of payment method detail items.
      class PaymentMethodDetailItemList < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
