# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # An array of package objects in a container.
      class Packages < Array
        class << self
          def parse(array)
            new(array.map { |item| Package.parse(item) })
          end
        end
      end
    end
  end
end
