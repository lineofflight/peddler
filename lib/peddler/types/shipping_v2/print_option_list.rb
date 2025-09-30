# frozen_string_literal: true

require "peddler/types/shipping_v2/print_option"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of the format options for a label.
      class PrintOptionList < Array
        class << self
          def parse(array)
            new(array.map { |item| PrintOption.parse(item) })
          end
        end
      end
    end
  end
end
