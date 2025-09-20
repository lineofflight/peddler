# frozen_string_literal: true

module Peddler
  module Types
    module NotificationsV1
      # A list of marketplace identifiers to subscribe to (for example: ATVPDKIKX0DER). To receive notifications in
      # every marketplace, do not provide this list.
      class MarketplaceIds < Array
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
