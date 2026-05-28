# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class OrdersV0
      # Pre-approved alternative product attributes available for a rejected order. Each element contains an attribute
      # name, its original value from the rejected order, and the corrected value that would result in approval (for
      # example, a substituted `asin` or adjusted `petWeight`).
      class ApprovedAlternativeDetails < Array
        class << self
          def parse(array)
            new(array.map { |item| ApprovedAttribute.parse(item) })
          end
        end
      end
    end
  end
end
