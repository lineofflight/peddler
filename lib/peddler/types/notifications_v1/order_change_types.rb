# frozen_string_literal: true

module Peddler
  module Types
    module NotificationsV1
      # A list of order change types to subscribe to (for example: `BuyerRequestedChange`). To receive notifications of
      # all change types, do not provide this list.
      class OrderChangeTypes < Array
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
