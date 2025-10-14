# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class OrdersV0
      # A collection of substitution options.
      class SubstitutionOptionList < Array
        class << self
          def parse(array)
            new(array.map { |item| SubstitutionOption.parse(item) })
          end
        end
      end
    end
  end
end
