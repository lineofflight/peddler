# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ListingsItems20210801
      # The issues associated with the listings item.
      class ItemIssues < Array
        class << self
          def parse(array)
            new(array.map { |item| Issue.parse(item) })
          end
        end
      end
    end
  end
end
