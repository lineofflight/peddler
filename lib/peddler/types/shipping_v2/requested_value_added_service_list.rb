# frozen_string_literal: true

require "peddler/types/shipping_v2/requested_value_added_service"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # The value-added services to be added to a shipping service purchase.
      class RequestedValueAddedServiceList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| RequestedValueAddedService.parse(item) }) : new
          end
        end
      end
    end
  end
end
