# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class NotificationsV1
      # A list of marketplace identifiers to subscribe to (for example: ATVPDKIKX0DER). To receive notifications in
      # every marketplace, do not provide this list.
      class MarketplaceIds < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
