# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A list of delivery documents for a package.
      class DeliveryDocumentList < Array
        class << self
          def parse(array)
            new(array.map { |item| DeliveryDocument.parse(item) })
          end
        end
      end
    end
  end
end
