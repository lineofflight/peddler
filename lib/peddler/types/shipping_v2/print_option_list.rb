# frozen_string_literal: true

require "peddler/types/shipping_v2/print_option"

module Peddler
  module Types
    module ShippingV2
      # A list of the format options for a label.
      class PrintOptionList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PrintOption.parse(item) })
          end
        end
      end
    end
  end
end
