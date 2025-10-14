# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV1
      # A list of container specifications.
      class ContainerSpecificationList < Array
        class << self
          def parse(array)
            new(array.map { |item| ContainerSpecification.parse(item) })
          end
        end
      end
    end
  end
end
