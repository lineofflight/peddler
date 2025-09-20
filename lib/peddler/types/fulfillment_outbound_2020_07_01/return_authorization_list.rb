# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/return_authorization"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of return authorization information.
      class ReturnAuthorizationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ReturnAuthorization.parse(item) })
          end
        end
      end
    end
  end
end
