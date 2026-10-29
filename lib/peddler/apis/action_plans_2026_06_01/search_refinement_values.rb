# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ActionPlans20260601
      # The set of values available for a single search refinement.
      class SearchRefinementValues < Array
        class << self
          def parse(array)
            new(array.map { |item| SearchRefinementValue.parse(item) })
          end
        end
      end
    end
  end
end
