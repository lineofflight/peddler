# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class VendorOrdersV1
      # Detailed description of items order status.
      class ItemStatus < Array
        class << self
          def parse(array)
            new(array.map { |item| OrderItemStatus.parse(item) })
          end
        end
      end
    end
  end
end
