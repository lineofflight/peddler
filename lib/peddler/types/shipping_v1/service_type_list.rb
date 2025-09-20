# frozen_string_literal: true

module Peddler
  module Types
    module ShippingV1
      # A list of service types that can be used to send the shipment.
      class ServiceTypeList < Array
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
