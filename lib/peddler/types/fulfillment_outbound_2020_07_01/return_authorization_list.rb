# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/return_authorization"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of return authorization information.
      class ReturnAuthorizationList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ReturnAuthorization.parse(item) }) : new
          end
        end
      end
    end
  end
end
