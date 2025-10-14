# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of tax detail information.
      class TaxDetailList < Array
        class << self
          def parse(array)
            new(array.map { |item| TaxDetail.parse(item) })
          end
        end
      end
    end
  end
end
