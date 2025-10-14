# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # Specify the type of attributes to be added on a label.
      class RequestAttributes < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
