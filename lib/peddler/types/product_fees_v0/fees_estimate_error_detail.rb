# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductFeesV0
      # Additional information that can help the caller understand or fix the issue.
      class FeesEstimateErrorDetail < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
