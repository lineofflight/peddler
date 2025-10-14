# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Notifications
    # Listings Item Status Change Notification
    #
    # To be delivered when the status (e.g. buyability, discoverability) of a listings item changes.
    module ListingsItemStatusChange
      class << self
        def parse(hash)
          Notification.parse(hash)
        end
      end
    end
  end
end
