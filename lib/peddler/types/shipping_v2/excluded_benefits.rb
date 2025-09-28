# frozen_string_literal: true

require "peddler/types/shipping_v2/excluded_benefit"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of excluded benefit. Refer to the ExcludeBenefit object for further documentation
      class ExcludedBenefits < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ExcludedBenefit.parse(item) }) : new
          end
        end
      end
    end
  end
end
