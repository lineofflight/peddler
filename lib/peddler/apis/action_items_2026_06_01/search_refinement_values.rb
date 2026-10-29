# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ActionItems20260601
      # The list of refinement values for a given refinement key.
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
