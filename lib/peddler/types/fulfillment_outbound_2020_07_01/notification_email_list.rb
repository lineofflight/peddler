# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A list of email addresses that the seller provides that are used by Amazon to send ship-complete notifications
      # to recipients on behalf of the seller.
      class NotificationEmailList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
