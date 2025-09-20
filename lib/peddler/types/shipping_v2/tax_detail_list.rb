# frozen_string_literal: true

require "peddler/types/shipping_v2/tax_detail"

module Peddler
  module Types
    module ShippingV2
      # A list of tax detail information.
      class TaxDetailList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TaxDetail.parse(item) })
          end
        end
      end
    end
  end
end
