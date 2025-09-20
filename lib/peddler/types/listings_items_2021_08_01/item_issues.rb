# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/issue"

module Peddler
  module Types
    module ListingsItems20210801
      # The issues associated with the listings item.
      class ItemIssues < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Issue.parse(item) })
          end
        end
      end
    end
  end
end
