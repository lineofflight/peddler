# frozen_string_literal: true

require "peddler/types/shipping_v2/package"

module Peddler
  module Types
    module ShippingV2
      # A list of packages to be shipped through a shipping service offering.
      class PackageList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Package.parse(item) })
          end
        end
      end
    end
  end
end
