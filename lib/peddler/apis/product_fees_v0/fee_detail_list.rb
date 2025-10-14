# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductFeesV0
      # A list of other fees that contribute to a given fee.
      class FeeDetailList < Array
        class << self
          def parse(array)
            new(array.map { |item| FeeDetail.parse(item) })
          end
        end
      end
    end
  end
end
