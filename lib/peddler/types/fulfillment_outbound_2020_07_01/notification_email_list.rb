# frozen_string_literal: true

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A list of email addresses that the seller provides that are used by Amazon to send ship-complete notifications
      # to recipients on behalf of the seller.
      class NotificationEmailList < Array
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
