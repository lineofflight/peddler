# frozen_string_literal: true

module Peddler
  module Types
    module ProductFeesV0
      # Additional information that can help the caller understand or fix the issue.
      class FeesEstimateErrorDetail < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end
