# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of various payment attributes related to this fulfillment order.
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
