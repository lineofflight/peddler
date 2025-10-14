# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Notifications
    module DetailPageTrafficEvent
      class DetailPageTrafficEvents < Array
        class << self
          def parse(array)
            new(array.map { |item| DetailPageTrafficEvent.parse(item) })
          end
        end
      end
    end
  end
end
