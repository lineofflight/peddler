# frozen_string_literal: true

require "peddler/types/shipping_v2/package"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of packages to be shipped through a shipping service offering.
      class PackageList < Array
        class << self
          def parse(array)
            new(array.map { |item| Package.parse(item) })
          end
        end
      end
    end
  end
end
