# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Notifications
    module ItemSalesEventChange
      class ItemSalesEventChanges < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemSalesEventChange.parse(item) })
          end
        end
      end
    end
  end
end
