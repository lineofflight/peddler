# frozen_string_literal: true

require "peddler/types/orders_v0/substitution_option"

module Peddler
  module Types
    module OrdersV0
      # A collection of substitution options.
      class SubstitutionOptionList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SubstitutionOption.parse(item) })
          end
        end
      end
    end
  end
end
