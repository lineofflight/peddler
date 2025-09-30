# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV1
      # A list of service types that can be used to send the shipment.
      class ServiceTypeList < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
