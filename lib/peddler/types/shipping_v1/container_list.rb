# frozen_string_literal: true

require "peddler/types/shipping_v1/container"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV1
      # A list of container.
      class ContainerList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Container.parse(item) }) : new
          end
        end
      end
    end
  end
end
