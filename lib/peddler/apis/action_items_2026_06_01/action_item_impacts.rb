# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ActionItems20260601
      # The business impacts associated with an action item.
      class ActionItemImpacts < Array
        class << self
          def parse(array)
            new(array.map { |item| Impact.parse(item) })
          end
        end
      end
    end
  end
end
