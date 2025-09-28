# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module NotificationsV1
      # A list of order change types to subscribe to (for example: `BuyerRequestedChange`). To receive notifications of
      # all change types, do not provide this list.
      class OrderChangeTypes < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
