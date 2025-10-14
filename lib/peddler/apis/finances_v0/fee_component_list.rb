# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of fee component information.
      class FeeComponentList < Array
        class << self
          def parse(array)
            new(array.map { |item| FeeComponent.parse(item) })
          end
        end
      end
    end
  end
end
