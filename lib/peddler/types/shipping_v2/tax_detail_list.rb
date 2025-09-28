# frozen_string_literal: true

require "peddler/types/shipping_v2/tax_detail"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of tax detail information.
      class TaxDetailList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| TaxDetail.parse(item) }) : new
          end
        end
      end
    end
  end
end
