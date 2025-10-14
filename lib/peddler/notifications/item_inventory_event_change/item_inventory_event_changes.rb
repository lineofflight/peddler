# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Notifications
    module ItemInventoryEventChange
      class ItemInventoryEventChanges < Array
        class << self
          def parse(array)
            new(array.map { |item| ItemInventoryEventChange.parse(item) })
          end
        end
      end
    end
  end
end
