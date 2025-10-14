# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Notifications
    # Listings Item MFN Quantity Change Notification
    #
    # To be delivered when the inventory quantity of a MFN Seller listing changes.
    module ListingsItemMfnQuantityChange
      class << self
        def parse(hash)
          Notification.parse(hash)
        end
      end
    end
  end
end
