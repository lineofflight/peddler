# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # List of payment transactions
      class PaymentInformationList < Array
        class << self
          def parse(array)
            new(array.map { |item| PaymentInformation.parse(item) })
          end
        end
      end
    end
  end
end
