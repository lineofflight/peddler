# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class NotificationsV1
      # A list of subscriptions.
      class Subscriptions < Array
        class << self
          def parse(array)
            new(array.map { |item| Subscription.parse(item) })
          end
        end
      end
    end
  end
end
