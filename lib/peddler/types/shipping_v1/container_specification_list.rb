# frozen_string_literal: true

require "peddler/types/shipping_v1/container_specification"

module Peddler
  module Types
    module ShippingV1
      # A list of container specifications.
      class ContainerSpecificationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ContainerSpecification.parse(item) })
          end
        end
      end
    end
  end
end
